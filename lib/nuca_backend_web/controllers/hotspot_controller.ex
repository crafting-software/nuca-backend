defmodule NucaBackendWeb.HotspotController do
  use NucaBackendWeb, :controller

  alias NucaBackend.Hotspots
  alias NucaBackend.Hotspots.Hotspot

  def index(conn, _params) do
    hotspots = Hotspots.list_hotspots()
    render(conn, "index.json", hotspots: hotspots)
  end

  def new(conn, _params) do
    changeset = Hotspots.change_hotspot(%Hotspot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hotspot" => hotspot_params}) do
    case Hotspots.create_hotspot(hotspot_params) do
      {:ok, hotspot} ->
        conn
        |> put_flash(:info, "Hotspot created successfully.")
        |> redirect(to: Routes.hotspot_path(conn, :show, hotspot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    hotspot = Hotspots.get_hotspot!(id)
    render(conn, "hotspot_details.json", hotspot: hotspot)
  end

  def edit(conn, %{"id" => id}) do
    hotspot = Hotspots.get_hotspot!(id)
    changeset = Hotspots.change_hotspot(hotspot)
    render(conn, "edit.html", hotspot: hotspot, changeset: changeset)
  end

  def update(conn, hotspot_params) do
    hotspot = Hotspots.get_hotspot!(hotspot_params["id"])

    case Hotspots.update_hotspot(hotspot, hotspot_params) do
      {:ok, hotspot} ->
        conn
        |> put_flash(:info, "Hotspot updated successfully.")
        |> redirect(to: Routes.hotspot_path(conn, :show, hotspot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", hotspot: hotspot, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hotspot = Hotspots.get_hotspot!(id)
    {:ok, _hotspot} = Hotspots.delete_hotspot(hotspot)

    conn
    |> put_flash(:info, "Hotspot deleted successfully.")
    |> redirect(to: Routes.hotspot_path(conn, :index))
  end
end
