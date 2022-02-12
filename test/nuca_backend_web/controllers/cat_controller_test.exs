defmodule NucaBackendWeb.CatControllerTest do
  use NucaBackendWeb.ConnCase

  import NucaBackend.CatsFixtures

  alias NucaBackend.Cats.Cat

  @create_attrs %{
    capturer_id: "7488a646-e31f-11e4-aace-600308960662",
    check_in_date: ~D[2022-02-10],
    check_out_date: ~D[2022-02-10],
    description: "some description",
    hotspot_id: "7488a646-e31f-11e4-aace-600308960662",
    is_imported: true,
    is_sterilized: true,
    media: %{},
    notes: "some notes",
    raw_address: "some raw_address",
    sex: "M"
  }
  @update_attrs %{
    capturer_id: "7488a646-e31f-11e4-aace-600308960668",
    check_in_date: ~D[2022-02-11],
    check_out_date: ~D[2022-02-11],
    description: "some updated description",
    hotspot_id: "7488a646-e31f-11e4-aace-600308960668",
    is_imported: false,
    is_sterilized: false,
    media: %{},
    notes: "some updated notes",
    raw_address: "some updated raw_address",
    sex: "M"
  }
  @invalid_attrs %{
    capturer_id: nil,
    check_in_date: nil,
    check_out_date: nil,
    description: nil,
    hotspot_id: nil,
    is_imported: nil,
    is_sterilized: nil,
    media: nil,
    notes: nil,
    raw_address: nil,
    sex: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cat", %{conn: conn} do
      conn = get(conn, Routes.cat_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cat" do
    test "renders cat when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cat_path(conn, :create), cat: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.cat_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "capturer_id" => "7488a646-e31f-11e4-aace-600308960662",
               "check_in_date" => "2022-02-10",
               "check_out_date" => "2022-02-10",
               "description" => "some description",
               "hotspot_id" => "7488a646-e31f-11e4-aace-600308960662",
               "is_imported" => true,
               "is_sterilized" => true,
               "media" => %{},
               "notes" => "some notes",
               "raw_address" => "some raw_address",
               "sex" => "M"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cat_path(conn, :create), cat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cat" do
    setup [:create_cat]

    test "renders cat when data is valid", %{conn: conn, cat: %Cat{id: id} = cat} do
      conn = put(conn, Routes.cat_path(conn, :update, cat), cat: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.cat_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "capturer_id" => "7488a646-e31f-11e4-aace-600308960668",
               "check_in_date" => "2022-02-11",
               "check_out_date" => "2022-02-11",
               "description" => "some updated description",
               "hotspot_id" => "7488a646-e31f-11e4-aace-600308960668",
               "is_imported" => false,
               "is_sterilized" => false,
               "media" => %{},
               "notes" => "some updated notes",
               "raw_address" => "some updated raw_address",
               "sex" => "M"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, cat: cat} do
      conn = put(conn, Routes.cat_path(conn, :update, cat), cat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cat" do
    setup [:create_cat]

    test "deletes chosen cat", %{conn: conn, cat: cat} do
      conn = delete(conn, Routes.cat_path(conn, :delete, cat))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.cat_path(conn, :show, cat))
      end
    end
  end

  defp create_cat(_) do
    cat = cat_fixture()
    %{cat: cat}
  end
end
