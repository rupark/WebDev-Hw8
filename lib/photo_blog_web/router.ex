defmodule PhotoBlogWeb.Router do
  use PhotoBlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PhotoBlogWeb.Plugs.FetchUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PhotoBlogWeb.Plugs.RequireAuth
  end

  scope "/", PhotoBlogWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController
    get "/users/:id/photo", UserController, :photo
    resources "/users", UserController
    resources "/comments", CommentController
    resources "/invites", InviteController

    resources "/sessions", SessionController,
      only: [:create, :delete], singleton: true
  end

  scope "/api", PhotoBlogWeb do
    pipe_through :api

    resources "/votes", VoteController, except: [:new, :edit]
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
      live_dashboard "/dashboard", metrics: PhotoBlogWeb.Telemetry
    end
  end
end
