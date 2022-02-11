defmodule NucaBackend.Repo.Migrations.CreateHotspot do
  use Ecto.Migration

  def change do
    create table(:hotspot, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add :latitude, :string
      add :longitude, :string
      add :street_name, :string
      add :street_number, :string
      add :city, :string
      add :zip, :string
      add :status, :string
      add :contact_name, :string
      add :contact_phone, :string
      add :notes, :text
      add :inactive_since, :naive_datetime
      add :total_unsterilized_cats, :integer

      timestamps()
    end
  end
end
