defmodule NucaBackendWeb.Plugs.RequireAuthorization do
  import Plug.Conn
  alias NucaBackendWeb.JwtAuthToken
  alias NucaBackendWeb.HttpUtils

  @auth_scheme "Bearer"

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:require_auth_header, {:ok, conn}} <-
           {:require_auth_header, conn |> require_auth_header},
         {:require_bearer_auth, {:ok, conn}} <-
           {:require_bearer_auth, conn |> require_bearer_auth} do
      jwt_token = bearer_auth_creds(conn)

      case JwtAuthToken.verify_and_validate(jwt_token) do
        {:ok, _} ->
          conn

        {:error, _} ->
          conn |> forbidden
      end
    else
      {_, {:error, reason, conn}} -> conn |> forbidden(reason)
    end
  end

  defp require_auth_header(conn) do
    if get_req_header(conn, "authorization") == [] do
      {:error, "Authentication info is missing.", conn}
    else
      {:ok, conn}
    end
  end

  defp require_bearer_auth(conn) do
    if bearer_auth?(conn) do
      {:ok, conn}
    else
      {:error, "Authentication token is malformed.", conn}
    end
  end

  defp bearer_auth?(conn) do
    conn
    |> get_authorization_header
    |> case do
      nil -> false
      string -> string |> String.starts_with?(@auth_scheme <> " ")
    end
  end

  defp bearer_auth_creds(conn) do
    conn
    |> get_authorization_header
    |> String.slice((String.length(@auth_scheme) + 1)..-1)
  end

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first()
  end

  defp forbidden(conn, message \\ "Forbidden") do
    conn
    |> HttpUtils.unauthorized(message)
    |> halt()
  end
end
