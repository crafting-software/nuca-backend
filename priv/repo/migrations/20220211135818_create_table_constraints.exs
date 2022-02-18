defmodule NucaBackend.Repo.Migrations.CreateTableConstraints do
  use Ecto.Migration

  def change do
    alter table(:hotspot) do
      remove :volunteer_id
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
