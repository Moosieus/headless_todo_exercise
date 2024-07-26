defmodule Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo
  alias Todo.Accounts.User

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists(user)
      [%Todo.List{}, ...]

  """
  def list_lists(%User{id: user_id}) do
    user_id
    |> Todo.List.with_user()
    |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(user, 123)
      %Todo.List{}

      iex> get_list!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(%User{id: user_id}, id) do
    user_id
    |> Todo.List.with_user()
    |> preload(:tasks)
    |> Repo.get!(id)
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %Todo.List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(%User{} = user, attrs \\ %{}) do
    %Todo.List{user: user}
    |> Todo.List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %Todo.List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%Todo.List{} = list, attrs \\ %{}) do
    list
    |> Todo.List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %Todo.List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%Todo.List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %Todo.List{}}

  """
  def change_list(%Todo.List{} = list, attrs \\ %{}) do
    Todo.List.changeset(list, attrs)
  end

  def get_task!(%User{id: user_id}, id) do
    user_id
    |> Todo.List.Task.with_user()
    |> Repo.get!(id)
  end

  @doc """
  Creates a task on a list.

  ## Examples

      iex> create_task(list, %{field: value})
      {:ok, %Todo.List.Task{}}

      iex> create_task(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(%Todo.List{} = list, attrs \\ %{}) do
    %Todo.List.Task{list: list}
    |> Todo.List.Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Todo.List.Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Todo.List.Task{} = task, attrs) do
    task
    |> Todo.List.Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Todo.List.Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Todo.List.Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Todo.List.Task{}}

  """
  def change_task(%Todo.List.Task{} = task, attrs \\ %{}) do
    Todo.List.Task.changeset(task, attrs)
  end
end
