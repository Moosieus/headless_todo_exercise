defmodule TodoWeb.ListJSON do
  @doc """
  Renders a list of lists.
  """
  def index(%{lists: lists}) do
    %{data: for(list <- lists, do: data(list))}
  end

  @doc """
  Renders a single list or task.
  """
  def show(%{list: list}) do
    %{data: data(list)}
  end

  def show(%{task: task}) do
    %{data: task}
  end

  defp data(%Todo.List{tasks: tasks} = list) when is_list(tasks) do
    %{
      id: list.id,
      title: list.title,
      tasks: list.tasks,
      inserted_at: list.inserted_at,
      updated_at: list.updated_at
    }
  end

  defp data(%Todo.List{} = list) do
    %{
      id: list.id,
      title: list.title,
      inserted_at: list.inserted_at,
      updated_at: list.updated_at
    }
  end
end
