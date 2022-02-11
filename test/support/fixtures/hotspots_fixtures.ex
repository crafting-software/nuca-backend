defmodule NucaBackend.HotspotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NucaBackend.Hotspots` context.
  """

  @doc """
  Generate a hotspot.
  """
  def hotspot_fixture(attrs \\ %{}) do
    {:ok, hotspot} =
      attrs
      |> Enum.into(%{
        city: "some city",
        contact_name: "some contact_name",
        contact_phone: "some contact_phone",
        inactive_since: ~N[2022-02-10 12:09:00],
        latitude: "some latitude",
        longitude: "some longitude",
        notes: "some notes",
        status: "ToDo",
        street_name: "some street_name",
        street_number: "some street_number",
        total_unsterilized_cats: 42,
        zip: "some zip"
      })
      |> NucaBackend.Hotspots.create_hotspot()

    hotspot
  end
end
