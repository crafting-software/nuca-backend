defmodule NucaBackend.Cats.Media.CatPicture do
  use NucaBackend.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset

  alias NucaBackendWeb.UUID

  schema "cat_picture" do
    belongs_to :cat, NucaBackend.Cats.Cat
    field :url, NucaBackend.Uploaders.CatPicture.Type

    timestamps()
  end

  def changeset(media, %{"url" => %Plug.Upload{}} = attrs) do
    media
    |> cast(attrs, [:cat_id])
    |> validate_required([:cat_id])
    |> UUID.check_uuid()
    |> cast_attachments(attrs, [:url])
  end
end
