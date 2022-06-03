defmodule NucaBackend.Cats do
  require OK
  import Ecto.Query, warn: false
  alias NucaBackend.Repo

  alias NucaBackend.Cats.Cat

  def list_cat do
    Repo.all(Cat) |> Repo.preload([:captured_by])
  end

  def get_cat!(id), do: Repo.get!(Cat, id) |> Repo.preload([:captured_by])

  def create_cat(attrs \\ %{}) do
    %Cat{}
    |> Cat.changeset(attrs)
    |> Repo.insert()
    |> OK.flat_map(fn (h) -> {:ok, Repo.preload(h, [:captured_by])} end)
  end

  def update_cat(%Cat{} = cat, attrs) do
    cat
    |> Cat.changeset(attrs)
    |> Repo.update()
    |> OK.flat_map(fn (h) -> {:ok, Repo.preload(h, [:captured_by])} end)
  end

  def delete_cat(%Cat{} = cat) do
    Repo.delete(cat)
  end

  def change_cat(%Cat{} = cat, attrs \\ %{}) do
    Cat.changeset(cat, attrs)
  end
end
