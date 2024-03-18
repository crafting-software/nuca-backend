defmodule NucaBackendWeb.UUID do
  import Ecto.Changeset

  def check_uuid(changeset, field \\ :id) do
    case get_field(changeset, field) do
      nil ->
        force_change(changeset, field, Ecto.UUID.generate())

      _ ->
        changeset
    end
  end
end
