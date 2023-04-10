defmodule Portserver.StorageBackend.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :data, Portserver.Encrypted.Binary, redact: true
    field :donation_id, :string
    field :participant_id, :string

    timestamps()
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:data, :donation_id, :participant_id])
  end
end
