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

  def create(conn, hotspot_params) do
    case Hotspots.create_hotspot(hotspot_params) do
      {:ok, hotspot} ->
        render(conn, "hotspot_details.json", hotspot: hotspot)
      {:error, %Ecto.Changeset{} = changeset} ->
        send_resp(conn, 400, "invalid data for hotspot creation")
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
        render(conn, "hotspot_details.json", hotspot: hotspot)

      {:error, %Ecto.Changeset{} = changeset} ->
        send_resp(conn, 400, "invalid data for hotspot update")
    end
  end

  def delete(conn, params) do
    hotspot = Hotspots.get_hotspot!(params["id"])

    case Hotspots.delete_hotspot(hotspot) do
      {:ok, hotspot} ->
        send_resp(conn, 200, "Hotspot successfully deleted")

      {:error, %Ecto.Changeset{} = changeset} ->
        send_resp(conn, 400, "invalid data for hotspot delete")
    end
  end
end
