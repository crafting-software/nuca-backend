defmodule NucaBackend.Cats.Cat do
  use NucaBackend.Schema
  import Ecto.Changeset

  alias NucaBackend.Cats.Media.CatPicture
  alias NucaBackend.Users.User

  schema "cat" do
    field :check_in_date, :date
    field :check_out_date, :date
    field :description, :string
    field :hotspot_id, Ecto.UUID
    field :is_imported, :boolean, default: false
    field :is_sterilized, :boolean, default: false
    has_many :media, CatPicture, on_replace: :delete
    field :notes, :string
    field :raw_address, :string
    field :sex, :string
    belongs_to :captured_by, User, foreign_key: :capturer_id, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(cat, attrs) do
    cat
    |> cast(attrs, [
      :description,
      :sex,
      :is_sterilized,
      :check_in_date,
      :check_out_date,
      :capturer_id,
      :notes,
      :raw_address,
      :hotspot_id,
      :is_imported
    ])
    |> change()
    |> put_assoc(:captured_by, attrs.captured_by)
    |> validate_required([:sex, :is_sterilized, :hotspot_id, :is_imported])
    |> validate_inclusion(:sex, ["M", "F"])
  end
end
