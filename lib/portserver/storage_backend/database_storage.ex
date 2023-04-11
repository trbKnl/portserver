defmodule Portserver.StorageBackend.DatabaseStorage do
  alias Portserver.Repo
  alias Portserver.StorageBackend.Donation

  @behaviour Portserver.StorageBackend.Behaviour
  def store(participant_id, donation_id, data) do
    attrs = %{
      participant_id: participant_id,
      donation_id: donation_id,
      data: data
    }

    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert!(
      on_conflict: [set: [data: data]],
      conflict_target: [:participant_id, :donation_id]
    )
  end

  @folder "./data"
  @zipsizebytes 1_000_000_000

  @doc """
  Exports all donated data from the database it automatically 
  decrypts the data thanks to ecto_cloak. The exported data gets written
  to @folder in separate zipfiles in chunks of @zipsizebytes

  The function returns the filenames it has written

  ## Examples

    iex> Portserver.StorageBackend.DatabaseStorage.export_database()
    "export.zip"
  """
  def export_database() do
    {:ok, filenames} = Repo.transaction(fn ->
      Repo.stream(Donation)
      |> Stream.map(&construct_filename_and_data/1)
      |> Stream.chunk_while(
        {[], 0},
        &chunk_and_keep_track_of_bytes/2,
        &chunk_and_keep_track_of_bytes_after/1
      )
      |> Stream.with_index()
      |> Stream.map(&write_zip/1)
      |> Enum.into([])
    end)

    filenames
  end

  defp construct_filename_and_data(%Donation{
         data: data,
         donation_id: donation_id,
         participant_id: participant_id,
       }) do
    filename = to_charlist("#{participant_id}/#{donation_id}")
    {filename, data}
  end

  defp chunk_and_keep_track_of_bytes({_filename, data} = e, {acc, total_n_bytes}) do
    data_bytes = byte_size(data)

    if total_n_bytes < @zipsizebytes do
      {:cont, {[e | acc], total_n_bytes + data_bytes}}
    else
      {:cont, acc, {[e], data_bytes}}
    end
  end

  defp chunk_and_keep_track_of_bytes_after({acc, _total_n_bytes}) do
    {:cont, acc, []}
  end

  defp write_zip({to_zip, index}) do
    case {to_zip, index} do
      {_, 0} -> 
        :zip.create(Path.join(@folder, "export.zip"), to_zip)
        "export.zip"
      {_, _} -> 
          :zip.create(Path.join(@folder, "export_part_#{index}.zip"), to_zip)
          "export_part_#{index}.zip"
    end
  end

  def create_uri(filename) do
    Path.join(@folder, filename)
  end
end
