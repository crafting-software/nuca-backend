defmodule NucaBackendWeb.Router do
  use NucaBackendWeb, :router
  alias NucaBackendWeb.Plugs.RequireAuthorization

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug(:fetch_flash)
    plug :fetch_live_flash
    plug :put_root_layout, {NucaBackendWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_authorization do
    plug RequireAuthorization
  end

  scope "/", NucaBackendWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", NucaBackendWeb do
    pipe_through :api

    post "/login", AuthController, :authenticate

    pipe_through :require_authorization

    resources "/users", UserController
    resources "/hotspots", HotspotController
    resources "/cats", CatController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NucaBackendWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
