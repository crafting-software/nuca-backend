defmodule NucaBackend.Repo.Migrations.ModifyHotspot do
  use Ecto.Migration

  def change do
    alter table(:hotspot) do
      remove :street_name
      remove :street_number
      add :address, :string
      add :description, :string
    end
  end
end
