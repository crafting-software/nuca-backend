defmodule NucaBackendWeb.CatView do
  use NucaBackendWeb, :view
  alias NucaBackendWeb.CatView

  def render("index.json", %{cat: cat}) do
    %{data: render_many(cat, CatView, "cat.json")}
  end

  def render("show.json", %{cat: cat}) do
    %{data: render_one(cat, CatView, "cat.json")}
  end

  def render("cat.json", %{cat: cat}) do
    %{
      id: cat.id,
      description: cat.description,
      sex: cat.sex,
      is_sterilized: cat.is_sterilized,
      check_in_date: cat.check_in_date,
      check_out_date: cat.check_out_date,
      captured_by: render_one(cat.captured_by, NucaBackendWeb.UserView, "user.json", as: :user),
      media: cat.media,
      notes: cat.notes
    }
  end
end
