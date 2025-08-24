defmodule LiftskitBackendWeb.Router do
  use LiftskitBackendWeb, :router

  import LiftskitBackendWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiftskitBackendWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug LiftskitBackendWeb.ApiAuthPlug
  end

  scope "/", LiftskitBackendWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", LiftskitBackendWeb do
    pipe_through :api

    post "/signin", UserSessionController, :signin
    post "/signup", UserSessionController, :signup
  end

  scope "/api", LiftskitBackendWeb do
    pipe_through [:api_auth]

    resources "/rooms", RoomController, only: [:index, :create, :delete]
    resources "/messages", MessageController, only: [:index, :create, :delete, :show, :update]
    get "/users/search", UserController, :search
    resources "/users", UserController, only: [:index, :show, :create, :update, :delete]
    get "/users/:user_id/conversations", MessageController, :conversations_with_user

    # Liftskit API
    resources "/official_exercises", OfficialExerciseController, only: [:index, :create, :delete]
    resources "/tags", TagController, only: [:index, :create, :delete]
    resources "/exercise_roots", ExerciseRootController, only: [:index, :create, :delete]
    resources "/exercises", ExerciseController, only: [:index, :create, :delete]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:liftskit_backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiftskitBackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LiftskitBackendWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LiftskitBackendWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", LiftskitBackendWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{LiftskitBackendWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
