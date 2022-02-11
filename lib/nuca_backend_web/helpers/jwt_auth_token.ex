defmodule NucaBackendWeb.JwtAuthToken do
  use Joken.Config

  @exp_time 60 * 60 * 24 * 180

  @impl true
  def token_config, do: default_claims(default_exp: @exp_time)

  def generate_jwt(claims: claims), do: generate_and_sign!(claims)
end
