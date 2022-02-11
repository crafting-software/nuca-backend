defmodule NucaBackend.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NucaBackend.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        full_name: "some full_name",
        inactive_since: ~N[2022-02-10 10:02:00],
        password_hash: "some password_hash",
        phone: "some phone",
        role: "some role",
        username: "some username"
      })
      |> NucaBackend.Users.create_user()

    user
  end
end
