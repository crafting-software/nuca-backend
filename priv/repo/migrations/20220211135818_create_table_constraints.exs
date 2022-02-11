defmodule NucaBackend.Repo.Migrations.CreateTableConstraints do
  use Ecto.Migration

  def change do
    alter table(:hotspot) do
      add :volunteer_id, references(:user)
    end

    alter table(:cat) do
      remove :hotspot_id
      remove :captured_by
      add :hotspot_id, references(:hotspot)
      add :capturer_id, references(:user)
    end
  end
end
