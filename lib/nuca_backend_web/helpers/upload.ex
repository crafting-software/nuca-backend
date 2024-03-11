defmodule NucaBackendWeb.Upload do
  def to_upload(%{"file" => "data:image/png;base64," <> base64_data}) do
    decoded_data = Base.decode64!(base64_data)
    file_name = "#{Ecto.UUID.generate()}.png"
    file_path ="#{Application.get_env(:nuca_backend, :local_temp_dir)}/#{file_name}"
    :ok = File.write(file_path, decoded_data)

    %Plug.Upload{
      content_type: "image/png",
      filename: file_name,
      path: file_path
    }
  end

  def format_uploads(params, from: field_name, formatter: formatter) do
    uploads = params[field_name]

    case uploads do
      nil -> []
      [] -> []
      list when is_list(list) -> Enum.map(list, fn item ->
        item
        |> to_upload()
        |> formatter.()
      end)
      item -> to_upload(item)
    end
  end

  def delete_temp_file(file_name) do
    case File.rm("#{Application.get_env(:nuca_backend, :local_temp_dir)}/#{file_name}") do
      :ok -> :ok
      {:error, _} -> :error
    end
  end
end
