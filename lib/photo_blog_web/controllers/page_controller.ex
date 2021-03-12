defmodule PhotoBlogWeb.PageController do
  use PhotoBlogWeb, :controller
  import PhotoBlogWeb.Helpers

  alias PhotoBlog.Posts

  def index(conn, _params) do
    posts = Posts.list_posts()
    # |> Posts.load_votes()
    render(conn, "index.html", posts: posts)
  end
end
