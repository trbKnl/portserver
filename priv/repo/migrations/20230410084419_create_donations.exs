defmodule Portserver.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :participant_id, :string
      add :donation_id, :string
      add :data, :binary

      timestamps()
    end

    create unique_index(:donations, [:participant_id, :donation_id])
  end
end
