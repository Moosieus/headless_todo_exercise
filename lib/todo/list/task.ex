defmodule Todo.List.Task do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "tasks" do
    field :text, :string
    belongs_to :list, Todo.List
    field :complete?, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:text, :complete?])
    |> validate_required([:text, :complete?])
    |> assoc_constraint(:list)
  end

  def with_user(user_id) do
    from(
      t in Todo.List.Task,
      join: l in assoc(t, :list),
      where: l.user_id == ^user_id
    )
  end
end

defimpl Jason.Encoder, for: Todo.List.Task do
  def encode(task, opts) do
    task
    |> Map.take([:id, :text, :complete?, :list_id, :inserted_at, :updated_at])
    |> Jason.Encode.map(opts)
  end
end
