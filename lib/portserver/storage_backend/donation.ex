defmodule Portserver.StorageBackend.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Portserver.Repo

  schema "donations" do
    field :data, Portserver.Encrypted.Binary, redact: true
    field :donation_id, :string
    field :participant_id, :string

    timestamps()
  end

  @behaviour Portserver.StorageBackend.Behaviour
  def store(participant_id, donation_id, data) do
    attrs = %{
      participant_id: participant_id,
      donation_id: donation_id,
      data: data
    }
    %Portserver.StorageBackend.Donation{}
    |> changeset(attrs)
    |> Repo.insert!(
      on_conflict: [set: [data: data]],
      conflict_target: [:participant_id, :donation_id]
    ) 
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:data, :donation_id, :participant_id])
  end
end

