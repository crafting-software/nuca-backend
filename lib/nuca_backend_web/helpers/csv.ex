defmodule NucaBackendWeb.CSV do
  @base_datatypes [:string, :integer, :float]
  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]

  def to_csv(data, fields, row_parser) do
    field_names =
      fields
      |> Enum.map(&elem(&1, 0))
      |> Enum.join("; ")

    values =
      data
      |> Enum.map(&parse_row(&1, fields, row_parser))
      |> Enum.join("\n")

    Enum.join([field_names, values], "\n")
  end

  defp parse_row(item, fields, row_parser) do
    field_types = Enum.map(fields, &elem(&1, 1))

    item
    |> row_parser.()
    |> Enum.zip(field_types)
    |> Enum.map(&cast/1)
    |> Enum.join("; ")
  end

  defp cast({nil, _}), do: ""
  defp cast({data, :string}), do: String.replace(data, ";", ",")
  defp cast({data, :integer}) when is_integer(data), do: data
  defp cast({data, :float}) when is_float(data), do: data

  defp cast({data, :date}),
    do:
      "#{String.pad_leading("#{data.day}", 2, "0")}/#{String.pad_leading("#{data.month}", 2, "0")}/#{data.year}"

  defp cast({data, {:tuple, element_types}}) when is_tuple(data) and is_tuple(element_types) do
    result =
      data
      |> Tuple.to_list()
      |> Enum.zip(Tuple.to_list(element_types))
      |> Enum.map(&cast/1)
      |> Enum.join(", ")

    "(#{result})"
  end

  defp cast({data, {:array, t}}) when t in @base_datatypes,
    do:
      data
      |> Enum.map(&cast({&1, t}))
      |> Enum.join(" ")

  def csv(conn, data, schema: schema, row_data_fn: func)
      when is_function(func) do
    response = to_csv(data, schema, func)

    conn
    |> put_resp_content_type("text/csv")
    |> send_resp(200, response)
  end
end
