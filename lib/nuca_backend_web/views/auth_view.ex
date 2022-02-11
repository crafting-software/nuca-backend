defmodule NucaBackendWeb.AuthView do
  use NucaBackendWeb, :view
  alias NucaBackendWeb.UserView

  def render("show.json", %{user: user, token: token}),
    do: UserView.render("show.json", user: user) |> Map.put(:token, token)
end
