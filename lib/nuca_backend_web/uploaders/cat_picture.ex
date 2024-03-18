defmodule NucaBackend.Uploaders.CatPicture do
  use Waffle.Definition

  use Waffle.Ecto.Definition

  @versions [:original]

  @allowed_extensions ~w(.jpeg .jpg .png)

  # Whitelist file extensions:
  defp get_extension(file_name) do
    file_name
    |> Path.extname()
    |> String.downcase()
  end

  def transform(:original, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250"}
  end

  def validate({file, _}) do
    file_extension = get_extension(file.file_name)

    case Enum.member?(@allowed_extensions, file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def storage_dir(_version, {file, scope}) do
    "uploads/images/#{scope.id}"
  end

  def filename(version, _) do
    version
  end
end
