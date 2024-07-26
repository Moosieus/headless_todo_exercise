defmodule TodoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo` context.
  """

  alias Todo.Accounts.User

  @doc """
  Generate a list.
  """
  def list_fixture(%User{} = user, attrs \\ %{title: "Placeholder"}, tasks? \\ true) do
    attrs = Enum.into(attrs, %{})

    {:ok, list} = Todo.create_list(user, attrs)

    if tasks? do
      Todo.Repo.preload(list, :tasks)
    else
      list
    end
  end

  def task_fixture(%Todo.List{} = list, attrs \\ %{text: "Placeholder"}) do
    attrs = Enum.into(attrs, %{})

    {:ok, task} = Todo.create_task(list, attrs)

    task
  end
end
