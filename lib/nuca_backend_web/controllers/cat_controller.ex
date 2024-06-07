defmodule NucaBackendWeb.CatController do
  use NucaBackendWeb, :controller

  alias NucaBackend.Cats
  alias NucaBackend.Cats.Cat

  alias NucaBackendWeb.Upload

  action_fallback NucaBackendWeb.FallbackController

  def index(conn, _params) do
    cat = Cats.list_cat()
    render(conn, "index.json", cat: cat)
  end

  def create(conn, cat_params) do
    params =
      Map.put(
        cat_params,
        "media",
        Upload.format_uploads(
          cat_params,
          from: "media",
          formatter: fn entry -> %{"url" => entry} end
        )
      )

    with {:ok, %Cat{} = cat} <- Cats.create_cat(params) do
      Enum.each(params["media"], fn media -> Upload.delete_temp_file(media["url"].filename) end)

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
    params =
      Map.put(
        cat_params,
        "media",
        Upload.format_uploads(
          cat_params,
          from: "media",
          formatter: fn entry -> %{"url" => entry} end
        )
      )
    cat = Cats.get_cat!(params["id"])

    with {:ok, %Cat{} = cat} <- Cats.update_cat(cat, params) do
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
