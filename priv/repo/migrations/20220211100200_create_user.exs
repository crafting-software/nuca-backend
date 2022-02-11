defmodule NucaBackend.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :role, :string
      add :full_name, :string
      add :phone, :string
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :inactive_since, :naive_datetime

      timestamps()
    end
  end
end
