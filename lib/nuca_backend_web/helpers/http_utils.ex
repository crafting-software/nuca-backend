defmodule NucaBackendWeb.HttpUtils do
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  def bad_request(conn, message \\ "Bad request format") do
    Logger.warn("Bad request: #{inspect(message)}")

    conn
    |> put_status(:bad_request)
    |> json(%{errorMsg: message})
  end

  def not_found(conn, message \\ "Not found") do
    Logger.warn("Not found: #{inspect(message)}")

    conn
    |> put_status(:not_found)
    |> json(%{errorMsg: message})
  end

  def unprocessable(conn, _ \\ "Unprocessable entity") do
    Logger.warn("Unprocessable entity")

    conn
    |> put_status(:unprocessable_entity)
  end

  def unauthorized(conn, message \\ "Unauthorized") do
    Logger.warn("Unauthorized")

    conn
    |> put_status(:unauthorized)
    |> json(%{errorMsg: message})
  end
end
