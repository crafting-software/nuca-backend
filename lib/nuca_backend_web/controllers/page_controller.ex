defmodule NucaBackendWeb.PageController do
  use NucaBackendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
