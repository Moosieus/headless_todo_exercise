defmodule Todo.List do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "lists" do
    field :title, :string
    belongs_to :user, Todo.Accounts.User

    has_many :tasks, Todo.List.Task,
      preload_order: [asc: :inserted_at, asc: :id],
      on_replace: :mark_as_invalid

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> assoc_constraint(:user)
    |> cast_assoc(:tasks)
    |> check_constraint(:title, name: :title_not_blank)
    |> unique_constraint([:user_id, :title], error_key: :title, message: "already exists")
  end

  def from_user(user_id) do
    from(l in Todo.List, where: l.user_id == ^user_id)
  end
end
