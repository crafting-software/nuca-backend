defmodule NucaBackend.Schemas.Hotspot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hotspot" do
    field :latitude, :string
    field :longitude, :string
    field :street_number, :integer
    field :contact_name, :string
    field :contact_phone, :string
    field :city, :string
    field :notes, :string
    field :status, :string
    field :street_name, :string
    field :zip, :string
    # volunteer_id
    field :inactive_since, :naive_datetime
    field :total_unsterilized_cats, :integer

    timestamps()
  end

  @doc false
  def changeset(hotspot, attrs) do
    hotspot
    |> cast(attrs, [:latitude, :longitude, :street_name, :street_number, :city, :zip, :status, :contact_name, :contact_phone, :inactive_since, :total_unsterilized_cats])
    |> validate_required([:latitude, :longitude, :street_name, :street_number, :city, :zip, :status, :contact_name, :contact_phone, :notes, :inactive_since, :total_unsterilized_cats])
  end
end
