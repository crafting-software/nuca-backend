defmodule NucaBackendWeb.CatController do
  use NucaBackendWeb, :controller

  alias NucaBackend.Cats
  alias NucaBackend.Cats.Cat

  action_fallback NucaBackendWeb.FallbackController

  def index(conn, _params) do
    cat = Cats.list_cat()
    render(conn, "index.json", cat: cat)
  end

  def create(conn, cat_params) do
    with {:ok, %Cat{} = cat} <- Cats.create_cat(cat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cat_path(conn, :show, cat))
      |> render("show.json", cat: cat)
    end
  end

  def show(conn, %{"id" => id}) do
    cat = Cats.get_cat!(id)
    render(conn, "show.json", cat: cat)
  end

  def update(conn, cat_params) do
    cat = Cats.get_cat!(cat_params["id"])

    with {:ok, %Cat{} = cat} <- Cats.update_cat(cat, cat_params) do
      render(conn, "show.json", cat: cat)
    end
  end

  def delete(conn, params) do
    cat = Cats.get_cat!(params["id"])

    with {:ok, %Cat{}} <- Cats.delete_cat(cat) do
      send_resp(conn, :no_content, "")
    end
  end
end
