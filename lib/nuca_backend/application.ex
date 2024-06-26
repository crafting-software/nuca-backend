defmodule NucaBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NucaBackend.Repo,
      # Start the Telemetry supervisor
      NucaBackendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: NucaBackend.PubSub},
      # Start the Endpoint (http/https)
      NucaBackendWeb.Endpoint
      # Start a worker by calling: NucaBackend.Worker.start_link(arg)
      # {NucaBackend.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NucaBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NucaBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @impl true
  def start_phase(:create_temp_folder_if_no_exists, :normal, phase_args) do
    temp_folder = System.get_env("NUCA_BACKEND_UPLOADS_TEMP_FOLDER") || "uploads_temp"

    if not File.exists?(temp_folder) do
      File.mkdir!(temp_folder)
    end

    :ok
  end
end
