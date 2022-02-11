defmodule NucaBackendWeb.UserController do
  use NucaBackendWeb, :controller
  alias NucaBackend.Users.User
  alias NucaBackend.Users
  alias NucaBackendWeb.HttpUtils

  def index(conn, _params) do
    users = Users.list_user()
    conn |> render("index.json", users: users)
  end

  def create(conn, %{"user" => %{"password" => _} = user_params}) do
    with {:ok, %User{} = user} <-
           Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    else
      {:error, _} ->
        conn |> HttpUtils.bad_request("could not create user")
    end
  end

  def create(conn, %{"user" => _}) do
    conn |> HttpUtils.bad_request("missing password")
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    conn |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:get_user, %User{} = user} <- {:get_user, Users.get_user(id)},
         {:update_user, {:ok, %User{} = updated_user}} <-
           {:update_user, Users.update_user(user, user_params)} do
      conn |> render("show.json", user: updated_user)
    else
      {:get_user, _} ->
        conn |> HttpUtils.not_found("user not found")

      {:update_user, _} ->
        conn |> HttpUtils.bad_request("could not update user")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:get_user, %User{} = user} <- {:get_user, Users.get_user(id)},
         {:delete_user, {:ok, %User{}}} <- {:delete_user, user |> Users.delete_user()} do
      conn |> json(%{})
    else
      {:get_user, _} ->
        conn |> HttpUtils.not_found("user not found")

      {:delete_user, _} ->
        conn |> HttpUtils.bad_request("could not delete user")
    end
  end
end
