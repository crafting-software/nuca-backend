defmodule NucaBackendWeb.AuthController do
  use NucaBackendWeb, :controller
  alias NucaBackend.Users
  alias NucaBackend.Users.User
  alias NucaBackendWeb.HttpUtils
  alias NucaBackendWeb.JwtAuthToken

  def authenticate(conn, %{"username" => username, "password" => password}) do
    with {:username_exists, %User{} = user} <-
           {:username_exists, Users.get_by_username(username)},
         {:is_correct_password, true} <-
           {:is_correct_password, Bcrypt.verify_pass(password, user.password_hash)} do
      conn
      |> render("show.json",
        user: user,
        token:
          JwtAuthToken.generate_jwt(
            claims: %{user_id: user.id, iat: DateTime.utc_now() |> DateTime.to_unix()}
          )
      )
    else
      {:username_exists, _} ->
        conn |> HttpUtils.unauthorized("credentials do not match")

      {:is_correct_password, _} ->
        conn |> HttpUtils.unauthorized("credentials do not match")
    end
  end
end
