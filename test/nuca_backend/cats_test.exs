defmodule NucaBackend.CatsTest do
  use NucaBackend.DataCase

  alias NucaBackend.Cats

  describe "cat" do
    alias NucaBackend.Cats.Cat

    import NucaBackend.CatsFixtures

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

    test "list_cat/0 returns all cat" do
      cat = cat_fixture()
      assert Cats.list_cat() == [cat]
    end

    test "get_cat!/1 returns the cat with given id" do
      cat = cat_fixture()
      assert Cats.get_cat!(cat.id) == cat
    end

    test "create_cat/1 with valid data creates a cat" do
      valid_attrs = %{
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

      assert {:ok, %Cat{} = cat} = Cats.create_cat(valid_attrs)
      assert cat.capturer_id == "7488a646-e31f-11e4-aace-600308960662"
      assert cat.check_in_date == ~D[2022-02-10]
      assert cat.check_out_date == ~D[2022-02-10]
      assert cat.description == "some description"
      assert cat.hotspot_id == "7488a646-e31f-11e4-aace-600308960662"
      assert cat.is_imported == true
      assert cat.is_sterilized == true
      assert cat.media == %{}
      assert cat.notes == "some notes"
      assert cat.raw_address == "some raw_address"
      assert cat.sex == "M"
    end

    test "create_cat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cats.create_cat(@invalid_attrs)
    end

    test "update_cat/2 with valid data updates the cat" do
      cat = cat_fixture()

      update_attrs = %{
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

      assert {:ok, %Cat{} = cat} = Cats.update_cat(cat, update_attrs)
      assert cat.capturer_id == "7488a646-e31f-11e4-aace-600308960668"
      assert cat.check_in_date == ~D[2022-02-11]
      assert cat.check_out_date == ~D[2022-02-11]
      assert cat.description == "some updated description"
      assert cat.hotspot_id == "7488a646-e31f-11e4-aace-600308960668"
      assert cat.is_imported == false
      assert cat.is_sterilized == false
      assert cat.media == %{}
      assert cat.notes == "some updated notes"
      assert cat.raw_address == "some updated raw_address"
      # assert cat.sex == "M"
    end

    test "update_cat/2 with invalid data returns error changeset" do
      cat = cat_fixture()
      assert {:error, %Ecto.Changeset{}} = Cats.update_cat(cat, @invalid_attrs)
      assert cat == Cats.get_cat!(cat.id)
    end

    test "delete_cat/1 deletes the cat" do
      cat = cat_fixture()
      assert {:ok, %Cat{}} = Cats.delete_cat(cat)
      assert_raise Ecto.NoResultsError, fn -> Cats.get_cat!(cat.id) end
    end

    test "change_cat/1 returns a cat changeset" do
      cat = cat_fixture()
      assert %Ecto.Changeset{} = Cats.change_cat(cat)
    end
  end
end
