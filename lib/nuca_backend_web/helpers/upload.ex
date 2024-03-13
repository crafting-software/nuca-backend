defmodule NucaBackendWeb.Upload do
  @media_types %{
    "image/png" => "png",
    "image/jpeg" => "jpg"
  }

  def upload_helper(media_type, base64_data) do
    decoded_data = Base.decode64!(base64_data)
    file_name = "#{Ecto.UUID.generate()}.#{@media_types[media_type]}"
    file_path = "#{Application.get_env(:nuca_backend, :local_temp_dir)}/#{file_name}"
    :ok = File.write(file_path, decoded_data)

    %Plug.Upload{
      content_type: @media_types[media_type],
      filename: file_name,
      path: file_path
    }
  end

  def to_upload(%{"file" => "data:image/png;base64," <> base64_data}) do
    upload_helper("image/png", base64_data)
  end

  def to_upload(%{"file" => "data:image/jpeg;base64," <> base64_data}),
    do: upload_helper("image/jpeg", base64_data)

  def to_upload(%{"url" => url}) do
    url
  end

  def format_uploads(params, from: field_name, formatter: formatter) do
    uploads = params[field_name]

    case uploads do
      nil ->
        []

      [] ->
        []

      list when is_list(list) ->
        Enum.map(list, fn item ->
          item
          |> to_upload()
          |> formatter.()
        end)

      map when is_map(map) ->
        map
        |> Map.values()
        |> Enum.map(fn item ->
          item
          |> to_upload()
          |> formatter.()
        end)

      item ->
        to_upload(item)
    end
  end

  def delete_temp_file(file_name) do
    case File.rm("#{Application.get_env(:nuca_backend, :local_temp_dir)}/#{file_name}") do
      :ok -> :ok
      {:error, _} -> :error
    end
  end
end
