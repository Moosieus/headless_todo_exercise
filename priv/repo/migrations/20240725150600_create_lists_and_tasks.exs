defmodule Todo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:lists, [:user_id])
    create constraint("lists", :title_not_blank, check: "title <> ''")
    create unique_index(:lists, [:user_id, :title])

    create table(:tasks) do
      add :complete?, :boolean, default: false, null: false
      add :text, :text, null: false, default: ""
      add :list_id, references(:lists, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
