# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhotoBlog.Repo.insert!(%PhotoBlog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhotoBlog.Repo
alias PhotoBlog.Users.User
alias PhotoBlog.Posts.Post
alias PhotoBlog.Photos

defmodule Inject do
  def photo(name) do
    photos = Application.app_dir(:photo_blog, "priv/photos")
    path = Path.join(photos, name)
    {:ok, hash} = Photos.save_photo(name, path)
    hash
  end
end

moon = Inject.photo("moon.jpg")
nature = Inject.photo("nature.jpg")

alice = Repo.insert!(%User{name: "alice", email: "alice@gmail.com", photo_hash: moon})
bob = Repo.insert!(%User{name: "bob", email: "bob@gmail.com", photo_hash: nature})

# moon = Inject.photo("moon.jpg")
# nature = Inject.photo("nature.jpg")

p1 = %Post{
  user_id: alice.id,
  # photo_hash: moon,
  body: "Alice says Hi!",
  title: "Birthday",
  eventDate: "1/2/22"
}
Repo.insert!(p1)

p2 = %Post{
  user_id: bob.id,
  # photo_hash: nature,
  body: "Bob ate Pizza!",
  title: "Pizza Party",
  eventDate: "1/3/22"
}
Repo.insert!(p2)
