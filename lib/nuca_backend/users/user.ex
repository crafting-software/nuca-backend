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
    # has_many :cats
    # has_many :hotspot

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:role, :full_name, :phone, :email, :username, :password_hash, :inactive_since])
    |> validate_required([
      :role,
      :full_name
      # :phone,
      # :email,
      # :username,
      # :password_hash,
    ])
  end
end
