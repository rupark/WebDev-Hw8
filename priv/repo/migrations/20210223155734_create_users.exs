defmodule PhotoBlog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string,
        null: false, default: ""
      add :photo_hash, :string

      timestamps()
    end

  end
end
