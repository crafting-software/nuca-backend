defmodule NucaBackend.Repo.Migrations.CreateHotspot do
  use Ecto.Migration

  def change do
    create table(:hotspot) do
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
      add(:volunteer_id, references(:user, type: :uuid), null: true)

      timestamps()
    end
  end
end
