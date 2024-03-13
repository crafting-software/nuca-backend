defmodule NucaBackend.Cats do
  require OK
  import Ecto.Query, warn: false
  alias NucaBackend.Repo

  alias NucaBackend.Cats.{Cat, Media.CatPicture}

  def list_cat do
    Repo.all(Cat) |> Repo.preload([:captured_by])
  end

  def get_cat!(id), do: Repo.get!(Cat, id) |> Repo.preload([:captured_by, :media])

  def create_cat(attrs \\ %{}) do
    result =
      %Cat{}
      |> Cat.changeset(attrs)
      |> Repo.insert()

    with {:result, {:ok, cat}} <- {:result, result},
         {:preload, cat} <- {:preload, Repo.preload(cat, [:captured_by, :media])},
         {:media, {:ok, media}} <- {:media, save_photos(cat, attrs["media"])},
         {:match, cat} <-
           {:match,
            %{
              cat
              | media:
                  media.new
                  |> Enum.filter(fn {status, _media} -> status == :ok end)
                  |> Enum.map(fn {:ok, media} -> media end)
            }} do
      {:ok, cat}
    else
      {:result, {:error, changeset}} -> {:error, changeset}
      _ -> {:error, %{}}
    end
  end

  def update_cat(%Cat{} = cat, attrs) do
    result = cat |> Cat.changeset(attrs) |> Repo.update()

    with {:result, {:ok, cat}} <- {:result, result},
         {:preload, cat} <- {:preload, Repo.preload(cat, [:captured_by, :media])},
         {:media, {:ok, media}} <- {:media, save_photos(cat, attrs["media"])},
         {:match, cat} <-
           {:match,
            %{
              cat
              | media:
                  (media.new ++ cat.media)
                  |> Enum.filter(fn
                    {status, _media} -> status == :ok
                    media -> media
                  end)
                  |> Enum.map(fn
                    {:ok, media} -> media
                    %CatPicture{} = picture -> picture
                  end)
            }} do
      {:ok, cat}
    else
      {:result, {:error, changeset}} -> {:error, changeset}
      _ -> {:error, %{}}
    end
  end

  def save_photos(%Cat{media: media} = cat, photos) when is_list(photos) do
    existing_photos =
      Enum.map(
        media,
        &%{url: NucaBackend.Uploaders.CatPicture.url({&1.url, &1}, :original), id: &1.id}
      )

    photos_from_params = Enum.map(photos, &%{url: &1["url"]})

    defaults = %{new: [], deleted: [], existing: []}

    existing_photos_urls = Enum.map(existing_photos, & &1.url)
    params_urls = Enum.map(photos_from_params, & &1.url)

    %{new: new, deleted: deleted} =
      Map.merge(
        defaults,
        Enum.group_by(photos_from_params ++ existing_photos, fn
          %{url: %Plug.Upload{}} ->
            :new

          %{url: url} when is_binary(url) ->
            if url in existing_photos_urls and url in params_urls, do: :existing, else: :deleted
        end)
      )

    deleted_ids = Enum.map(deleted, & &1.id)

    OK.for do
      inserted_media =
        Enum.map(new, fn media_params ->
          %CatPicture{}
          |> CatPicture.changeset(%{"url" => media_params.url, "cat_id" => cat.id})
          |> Repo.insert()
        end)

      {_, deleted_media} =
        Repo.delete_all(from(p in CatPicture, where: p.id in ^deleted_ids), returning: true)
    after
      %{new: inserted_media, deleted: deleted_media}
    end
  end

  def delete_cat(%Cat{} = cat) do
    Repo.delete(cat)
  end

  def change_cat(%Cat{} = cat, attrs \\ %{}) do
    Cat.changeset(cat, attrs)
  end
end
