defmodule Todo.List do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "lists" do
    field :title, :string
    belongs_to :user, Todo.Accounts.User
    has_many :tasks, Todo.List.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> cast_assoc(:user)
    |> cast_assoc(:tasks)
    |> validate_required([:title, :user])
    |> assoc_constraint(:user)
    |> check_constraint(:title, name: :title_not_blank)
  end

  def with_user(user_id) do
    from(l in Todo.List, preload: :user, where: l.user_id == ^user_id)
  end
end
