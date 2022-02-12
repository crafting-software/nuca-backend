defmodule NucaBackendWeb.HotspotControllerTest do
  use NucaBackendWeb.ConnCase

  import NucaBackend.HotspotsFixtures

  @create_attrs %{
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
  @update_attrs %{
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

  describe "index" do
    test "lists all hotspot", %{conn: conn} do
      conn = get(conn, Routes.hotspot_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hotspot"
    end
  end

  describe "new hotspot" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.hotspot_path(conn, :new))
      assert html_response(conn, 200) =~ "New Hotspot"
    end
  end

  describe "create hotspot" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.hotspot_path(conn, :create), hotspot: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.hotspot_path(conn, :show, id)

      conn = get(conn, Routes.hotspot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Hotspot"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hotspot_path(conn, :create), hotspot: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Hotspot"
    end
  end

  describe "edit hotspot" do
    setup [:create_hotspot]

    test "renders form for editing chosen hotspot", %{conn: conn, hotspot: hotspot} do
      conn = get(conn, Routes.hotspot_path(conn, :edit, hotspot))
      assert html_response(conn, 200) =~ "Edit Hotspot"
    end
  end

  describe "update hotspot" do
    setup [:create_hotspot]

    test "redirects when data is valid", %{conn: conn, hotspot: hotspot} do
      conn = put(conn, Routes.hotspot_path(conn, :update, hotspot), hotspot: @update_attrs)
      assert redirected_to(conn) == Routes.hotspot_path(conn, :show, hotspot)

      conn = get(conn, Routes.hotspot_path(conn, :show, hotspot))
      assert html_response(conn, 200) =~ "some updated city"
    end

    test "renders errors when data is invalid", %{conn: conn, hotspot: hotspot} do
      conn = put(conn, Routes.hotspot_path(conn, :update, hotspot), hotspot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Hotspot"
    end
  end

  describe "delete hotspot" do
    setup [:create_hotspot]

    test "deletes chosen hotspot", %{conn: conn, hotspot: hotspot} do
      conn = delete(conn, Routes.hotspot_path(conn, :delete, hotspot))
      assert redirected_to(conn) == Routes.hotspot_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.hotspot_path(conn, :show, hotspot))
      end
    end
  end

  defp create_hotspot(_) do
    hotspot = hotspot_fixture()
    %{hotspot: hotspot}
  end
end
