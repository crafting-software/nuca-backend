defmodule NucaBackend.Cats.Cat do
  use NucaBackend.Schema
  import Ecto.Changeset

  schema "cat" do
    field :captured_by, Ecto.UUID
    field :check_in_date, :date
    field :check_out_date, :date
    field :description, :string
    field :hotspot_id, Ecto.UUID
    field :is_imported, :boolean, default: false
    field :is_sterilized, :boolean, default: false
    field :media, :map
    field :notes, :string
    field :raw_address, :string
    field :sex, :string

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
      :captured_by,
      :media,
      :notes,
      :raw_address,
      :hotspot_id,
      :is_imported
    ])
    |> validate_required([:sex, :is_sterilized, :hotspot_id, :is_imported])
    |> validate_inclusion(:sex, ["M", "F"])
  end
end
