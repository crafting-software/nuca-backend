defmodule NucaBackendWeb.ReportController do
  use NucaBackendWeb, :controller
  alias NucaBackend.Cats
  import NucaBackendWeb.CSV, only: [csv: 3]

  @cat_csv_schema [
    {"Adresa", :string},
    {"Coordonate", {:tuple, {:string, :string}}},
    {"Data internare", :date},
    {"Data externare", :date},
    {"Sex", :string},
    {"Voluntar responsabil", :string},
    {"Media", {:array, :string}},
    {"Observatii", :string}
  ]

  defp get_coordinates(%{hotspot: %{latitude: lat, longitude: lng}}),
    do: {lat, lng}

  defp get_coordinates(_),
    do: {"0", "0"}

  defp cat_csv_values(cat),
    do: [
      cat.raw_address,
      get_coordinates(cat),
      cat.check_in_date,
      cat.check_out_date,
      cat.sex,
      if(not is_nil(cat.captured_by), do: cat.captured_by.full_name, else: ""),
      cat.media,
      cat.notes
    ]

  def index(conn, params) do
    cats = Cats.filter_cats(params)
    count = Enum.count(cats)
    csv(conn, cats, schema: @cat_csv_schema, row_data_fn: &cat_csv_values/1)
  end
end
