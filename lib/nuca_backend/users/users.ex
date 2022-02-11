defmodule NucaBackend.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias NucaBackend.Repo
  alias NucaBackend.Users.User
  import NucaBackendWeb.HashPassword

  def list_user do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def create_user(%{"password" => password} = attrs) do
    %User{}
    |> User.changeset(attrs |> Map.put("password_hash", hash_password(password)))
    |> Repo.insert()
  end

  def update_user(%User{} = user, %{"password" => password} = attrs) do
    user
    |> User.changeset(attrs |> Map.put("password_hash", hash_password(password)))
    |> Repo.update()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def get_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
