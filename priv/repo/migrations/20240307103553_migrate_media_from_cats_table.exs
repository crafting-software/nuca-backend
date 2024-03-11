defmodule NucaBackend.Repo.Migrations.MigrateMediaFromCatsTable do
  use Ecto.Migration

  def change do
    alter table(:cat) do
      remove :media, :map
    end

    create table(:cat_picture) do
      add :cat_id, references(:cat, on_delete: :delete_all)
      add :url, :string, null: false
      timestamps()
    end

    create index(:cat_picture, [:cat_id], name: :cat_picture_cat_id_index)
  end
end
