defmodule NucaBackend.Hotspots.Hotspot do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "hotspot" do
    field :city, :string
    field :contact_name, :string
    field :contact_phone, :string
    field :inactive_since, :naive_datetime
    field :latitude, :string
    field :longitude, :string
    field :notes, :string
    field :status, :string, default: "ToDo"
    field :street_name, :string
    field :street_number, :string
    field :total_unsterilized_cats, :integer
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(hotspot, attrs) do
    hotspot
    |> cast(attrs, [
      :id,
      :latitude,
      :longitude,
      :street_name,
      :street_number,
      :city,
      :zip,
      :status,
      :contact_name,
      :contact_phone,
      :notes,
      :inactive_since,
      :total_unsterilized_cats
    ])
    |> validate_required([:latitude, :longitude, :street_name])
    |> validate_inclusion(:status, ["ToDo", "InProgress", "Done"])
  end
end
