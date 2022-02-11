defmodule NucaBackend.Repo.Migrations.CreateCat do
  use Ecto.Migration

  def change do
    create table(:cat) do
      add :description, :text
      add :sex, :string
      add :is_sterilized, :boolean, default: false, null: false
      add :check_in_date, :date
      add :check_out_date, :date
      add :captured_by, :uuid
      add :media, :map
      add :notes, :text
      add :raw_address, :text
      add :hotspot_id, :uuid
      add :is_imported, :boolean, default: false, null: false

      timestamps()
    end
  end
end
