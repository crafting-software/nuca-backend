defmodule NucaBackend.Repo.Migrations.SetUsersDefaultPassword do
  use Ecto.Migration
  alias NucaBackend.Repo
  alias NucaBackend.Users.User
  import Ecto.Query

  def change do
    flush()
    
    from(
      u in User,
      where: is_nil(u.password_hash) or u.password_hash == "",
      update: [set: [password_hash: "$2a$12$fpNbRBTqg0iR530T8cp7CO1IOsbONDiud95pbCbzpM5gWWSxZcC.u"]] 
      # hash for 'Nuca123'
    )
    |> Repo.update_all([])

  end
end