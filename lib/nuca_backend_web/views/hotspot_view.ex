defmodule NucaBackendWeb.HotspotView do
  use NucaBackendWeb, :view
  alias NucaBackendWeb.HotspotView

  def render("index.json", %{hotspots: hotspots}),
    do: render_many(hotspots, HotspotView, "hotspot.json")

  def render("hotspot.json", %{hotspot: hotspot}),
    do: hotspot

  def render("hotspot_details.json", %{hotspot: hotspot}) do
    sterilized_cats = Enum.filter(hotspot.cats, fn cat -> cat.is_sterilized == true end)
    unsterilized_cats = hotspot.cats -- sterilized_cats

    hotspot
    |> Map.from_struct()
    |> Map.drop([:__meta__, :cats, :volunteer_id, :inserted_at, :updated_at])
    |> Map.put(
      :sterilized_cats,
      render_many(sterilized_cats, NucaBackendWeb.CatView, "cat.json", as: :cat)
    )
    |> Map.put(
      :unsterilized_cats,
      render_many(unsterilized_cats, NucaBackendWeb.CatView, "cat.json", as: :cat)
    )
    |> Map.put(
      :volunteer,
      render_one(hotspot.volunteer, NucaBackendWeb.UserView, "volunteer.json", as: :user)
    )
  end
end
