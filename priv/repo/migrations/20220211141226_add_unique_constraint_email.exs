defmodule NucaBackend.Repo.Migrations.AddUniqueConstraintEmail do
  use Ecto.Migration

  def change do
    create unique_index(:user, ~w/email/a, name: :unique_email)
    create unique_index(:user, ~w/username/a, name: :unique_username)
  end
end
