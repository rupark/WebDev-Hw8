defmodule PhotoBlogWeb.CommentController do
  use PhotoBlogWeb, :controller
  # import PhotoBlogWeb.Helpers

  alias PhotoBlog.Comments
  alias PhotoBlog.Comments.Comment

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    IO.inspect(comment_params)
    if Comments.exists(current_user_id(conn)) != nil do
      comment = Comments.get_comment!(Comments.exists(current_user_id(conn)).id)
      # IO.inpect(comment_params)
      case Comments.update_comment(comment, comment_params) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Comment updated successfully.")
          |> redirect(to: Routes.post_path(conn, :show, comment.post_id))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", comment: comment, changeset: changeset)
      end
    else
      comment_params = comment_params
      |> Map.put("user_id", current_user_id(conn))
      case Comments.create_comment(comment_params) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Comment created successfully.")
          |> redirect(to: Routes.post_path(conn, :show, comment.post_id))

        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          render(conn, "new.html", changeset: changeset)
    end
  end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)
    # IO.inpect(comment_params)
    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :show, comment.post_id))
  end
end
