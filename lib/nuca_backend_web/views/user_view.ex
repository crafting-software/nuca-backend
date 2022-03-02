defmodule NucaBackendWeb.UserView do
  use NucaBackendWeb, :view
  alias NucaBackendWeb.UserView

  def render("index.json", %{users: users}), do: render_many(users, UserView, "user.json")

  def render("show.json", %{user: user}), do: render_one(user, UserView, "user.json")

  def render("user.json", %{user: user}),
    do:
      user
      |> Map.from_struct()
      |> Map.drop(~w/__meta__ inserted_at updated_at password password_hash/a)

  def render("volunteer.json", %{user: user}),
    do:
      user
      |> Map.from_struct()
      |> Map.drop(
        ~w/__meta__ inserted_at updated_at password_hash role username email inactive_since/a
      )
end
