defmodule NucaBackend.Users.User do
  use NucaBackend.Schema
  import Ecto.Changeset

  schema "user" do
    field :email, :string
    field :full_name, :string
    field :inactive_since, :naive_datetime
    field :password_hash, :string
    field :phone, :string
    field :role, :string
    field :username, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :role,
      :full_name,
      :phone,
      :email,
      :username,
      :password_hash,
      :inactive_since,
      :password
    ])
    |> validate_required([
      :role,
      :full_name,
      :phone,
      :email,
      :username,
      :password_hash,
      :password
    ])
    |> validate_length(:password, min: 8, max: 20)
    |> validate_format(:email, ~r/.*@.*/)
    |> unique_constraint(:email, name: :unique_email)
    |> unique_constraint(:username, name: :unique_username)
  end
end
