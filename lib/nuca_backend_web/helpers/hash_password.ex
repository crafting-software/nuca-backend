defmodule NucaBackendWeb.HashPassword do
  def hash_password(password) when not is_nil(password),
    do: Bcrypt.Base.hash_password(password, Bcrypt.gen_salt(12, true))
end
