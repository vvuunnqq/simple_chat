defmodule Chatter.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :room_id, :string, null: false
      add :room_name, :string
      add :room_users, :string

      timestamps()
    end
  end
end
