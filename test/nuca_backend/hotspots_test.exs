defmodule NucaBackend.HotspotsTest do
  use NucaBackend.DataCase

  alias NucaBackend.Hotspots

  describe "hotspot" do
    alias NucaBackend.Hotspots.Hotspot

    import NucaBackend.HotspotsFixtures

    @invalid_attrs %{
      city: nil,
      contact_name: nil,
      contact_phone: nil,
      inactive_since: nil,
      latitude: nil,
      longitude: nil,
      notes: nil,
      status: nil,
      street_name: nil,
      street_number: nil,
      total_unsterilized_cats: nil,
      zip: nil
    }

    test "list_hotspot/0 returns all hotspot" do
      hotspot = hotspot_fixture()
      assert Hotspots.list_hotspots() == [hotspot]
    end

    test "get_hotspot!/1 returns the hotspot with given id" do
      hotspot = hotspot_fixture()
      assert Hotspots.get_hotspot!(hotspot.id) == hotspot
    end

    test "create_hotspot/1 with valid data creates a hotspot" do
      valid_attrs = %{
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
      }

      assert {:ok, %Hotspot{} = hotspot} = Hotspots.create_hotspot(valid_attrs)
      assert hotspot.city == "some city"
      assert hotspot.contact_name == "some contact_name"
      assert hotspot.contact_phone == "some contact_phone"
      assert hotspot.inactive_since == ~N[2022-02-10 12:09:00]
      assert hotspot.latitude == "some latitude"
      assert hotspot.longitude == "some longitude"
      assert hotspot.notes == "some notes"
      assert hotspot.status == "ToDo"
      assert hotspot.street_name == "some street_name"
      assert hotspot.street_number == "some street_number"
      assert hotspot.total_unsterilized_cats == 42
      assert hotspot.zip == "some zip"
    end

    test "create_hotspot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hotspots.create_hotspot(@invalid_attrs)
    end

    test "update_hotspot/2 with valid data updates the hotspot" do
      hotspot = hotspot_fixture()

      update_attrs = %{
        city: "some updated city",
        contact_name: "some updated contact_name",
        contact_phone: "some updated contact_phone",
        inactive_since: ~N[2022-02-11 12:09:00],
        latitude: "some updated latitude",
        longitude: "some updated longitude",
        notes: "some updated notes",
        status: "InProgress",
        street_name: "some updated street_name",
        street_number: "some updated street_number",
        total_unsterilized_cats: 43,
        zip: "some updated zip"
      }

      assert {:ok, %Hotspot{} = hotspot} = Hotspots.update_hotspot(hotspot, update_attrs)
      assert hotspot.city == "some updated city"
      assert hotspot.contact_name == "some updated contact_name"
      assert hotspot.contact_phone == "some updated contact_phone"
      assert hotspot.inactive_since == ~N[2022-02-11 12:09:00]
      assert hotspot.latitude == "some updated latitude"
      assert hotspot.longitude == "some updated longitude"
      assert hotspot.notes == "some updated notes"
      assert hotspot.status == "InProgress"
      assert hotspot.street_name == "some updated street_name"
      assert hotspot.street_number == "some updated street_number"
      assert hotspot.total_unsterilized_cats == 43
      assert hotspot.zip == "some updated zip"
    end

    test "update_hotspot/2 with invalid data returns error changeset" do
      hotspot = hotspot_fixture()
      assert {:error, %Ecto.Changeset{}} = Hotspots.update_hotspot(hotspot, @invalid_attrs)
      assert hotspot == Hotspots.get_hotspot!(hotspot.id)
    end

    test "delete_hotspot/1 deletes the hotspot" do
      hotspot = hotspot_fixture()
      assert {:ok, %Hotspot{}} = Hotspots.delete_hotspot(hotspot)
      assert_raise Ecto.NoResultsError, fn -> Hotspots.get_hotspot!(hotspot.id) end
    end

    test "change_hotspot/1 returns a hotspot changeset" do
      hotspot = hotspot_fixture()
      assert %Ecto.Changeset{} = Hotspots.change_hotspot(hotspot)
    end
  end
end
