defmodule NucaBackend.Cats do
  import Ecto.Query, warn: false
  alias NucaBackend.Repo

  alias NucaBackend.Cats.Cat

  def list_cat do
    Repo.all(Cat)
  end

  def get_cat!(id), do: Repo.get!(Cat, id)

  def create_cat(attrs \\ %{}) do
    %Cat{}
    |> Cat.changeset(attrs)
    |> Repo.insert()
  end

  def update_cat(%Cat{} = cat, attrs) do
    cat
    |> Cat.changeset(attrs)
    |> Repo.update()
  end

  def delete_cat(%Cat{} = cat) do
    Repo.delete(cat)
  end

  def change_cat(%Cat{} = cat, attrs \\ %{}) do
    Cat.changeset(cat, attrs)
  end
end
