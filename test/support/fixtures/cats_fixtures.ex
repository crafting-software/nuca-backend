defmodule NucaBackend.CatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NucaBackend.Cats` context.
  """

  @doc """
  Generate a cat.
  """
  def cat_fixture(attrs \\ %{}) do
    {:ok, cat} =
      attrs
      |> Enum.into(%{
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
      })
      |> NucaBackend.Cats.create_cat()

    cat
  end
end
