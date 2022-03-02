defmodule NucaBackend.Repo.Migrations.FirstData do
  use Ecto.Migration
  alias NucaBackend.Repo
  alias NucaBackend.Users.User
  import Ecto.Query

  def change do
    execute File.read!("priv/repo/pg_crypto.sql")
    execute File.read!("priv/repo/users.sql")
    execute File.read!("priv/repo/hotspots.sql")
    execute File.read!("priv/repo/cats.sql")
    
    flush()
    
    from(
      u in User,
      update: [set: [password_hash: "$2a$12$fpNbRBTqg0iR530T8cp7CO1IOsbONDiud95pbCbzpM5gWWSxZcC.u"]] 
      # hash for 'Nuca123'
    )
    |> Repo.update_all([])

  end
end
