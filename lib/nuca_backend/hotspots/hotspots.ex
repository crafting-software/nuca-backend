defmodule NucaBackend.Hotspots do
  require OK
  import Ecto.Query, warn: false
  alias NucaBackend.Repo
  alias NucaBackend.Hotspots.Hotspot
  alias NucaBackend.Users.User

  def list_hotspots do
    from(h in Hotspot,
      where: is_nil(h.inactive_since),
      select: %{
        id: h.id,
        longitude: h.longitude,
        latitude: h.latitude,
        status: h.status
      }
    )
    |> Repo.all()
  end

  def get_hotspot!(id),
    do:
      Repo.get!(Hotspot, id)
      |> Repo.preload([{:cats, [:captured_by, :media]}, :volunteer])

  def create_hotspot(attrs \\ %{}) do
    %Hotspot{}
    |> Hotspot.changeset(attrs)
    |> Repo.insert()
    |> OK.flat_map(fn h -> {:ok, Repo.preload(h, [{:cats, :captured_by}, :volunteer])} end)
  end

  def update_hotspot(%Hotspot{} = hotspot, attrs) do
    hotspot
    |> Hotspot.changeset(attrs)
    |> Repo.update()
    |> OK.flat_map(fn h ->
      new_volunteer = Repo.get!(User, h.volunteer_id)
      {:ok, Map.put(h, :volunteer, new_volunteer)}
    end)
  end

  def delete_hotspot(%Hotspot{} = hotspot) do
    Repo.delete(hotspot)
  end

  def change_hotspot(%Hotspot{} = hotspot, attrs \\ %{}) do
    Hotspot.changeset(hotspot, attrs)
  end
end
