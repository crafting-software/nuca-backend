defmodule NucaBackend.Hotspots do
  import Ecto.Query, warn: false
  alias NucaBackend.Repo

  alias NucaBackend.Hotspots.Hotspot

  def list_hotspots do
    Repo.all(Hotspot)
  end

  def get_hotspot!(id), do: Repo.get!(Hotspot, id)

  def create_hotspot(attrs \\ %{}) do
    %Hotspot{}
    |> Hotspot.changeset(attrs)
    |> Repo.insert()
  end

  def update_hotspot(%Hotspot{} = hotspot, attrs) do
    hotspot
    |> Hotspot.changeset(attrs)
    |> Repo.update()
  end

  def delete_hotspot(%Hotspot{} = hotspot) do
    Repo.delete(hotspot)
  end

  def change_hotspot(%Hotspot{} = hotspot, attrs \\ %{}) do
    Hotspot.changeset(hotspot, attrs)
  end
end
