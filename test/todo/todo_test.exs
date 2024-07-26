defmodule TodoTest do
  use Todo.DataCase

  describe "lists & tasks" do
    alias Todo.List

    import TodoFixtures
    import Todo.AccountsFixtures

    setup do
      user =
        user_fixture(%{
          email: "foo.bar@notarealwebsite.test",
          password: "P4ssW0rd!2024",
          confirmed_at: DateTime.utc_now(:second)
        })

      list = list_fixture(user)

      task = task_fixture(list)

      list = Todo.get_list!(user, list.id)

      %{
        user: user,
        list: list,
        task: task
      }
    end

    @invalid_list_attrs %{title: nil}
    @invalid_task_attrs %{text: nil}

    test "list_lists/0 returns lists ordered by title", %{user: user} do
      list2 = list_fixture(user, %{title: "B List 2"}, false)
      list3 = list_fixture(user, %{title: "A List 3"}, false)

      list_of_lists = Todo.list_lists(user)

      # ignore preloaded fixture
      assert match?([^list3, ^list2, %{title: "some title"}], list_of_lists)
    end

    test "get_list!/1 returns the list with given id", %{user: user, list: list} do
      assert Todo.get_list!(user, list.id) == list
    end

    test "create_list/1 with valid data creates a list", %{user: user} do
      valid_attrs = %{title: "a valid title"}

      assert {:ok, %List{} = list} = Todo.create_list(user, valid_attrs)
      assert list.title == "a valid title"
    end

    test "create_list/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Todo.create_list(user, @invalid_list_attrs)
    end

    test "update_list/2 with valid data updates the list", %{list: list} do
      update_attrs = %{title: "some updated title"}

      assert {:ok, %List{} = list} = Todo.update_list(list, update_attrs)
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset", %{user: user, list: list} do
      assert {:error, %Ecto.Changeset{}} = Todo.update_list(list, @invalid_list_attrs)
      assert list == Todo.get_list!(user, list.id)
    end

    test "delete_list/1 deletes the list", %{user: user, list: list} do
      assert {:ok, %List{}} = Todo.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_list!(user, list.id) end
    end

    test "change_list/1 returns a list changeset", %{list: list} do
      assert %Ecto.Changeset{} = Todo.change_list(list)
    end

    test "get_task!/1 returns the task with given id", %{user: user, task: task} do
      assert Todo.get_task!(user, task.id) == task
    end

    test "create_task/1 with valid data creates a task", %{list: list} do
      valid_attrs = %{text: "some text"}

      assert {:ok, %Todo.List.Task{} = task} = Todo.create_task(list, valid_attrs)
      assert task.text == "some text"
    end

    test "update_task/2 with valid data updates the task", %{task: task} do
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Todo.List.Task{} = task} = Todo.update_task(task, update_attrs)
      assert task.text == "some updated text"
    end

    test "update_task/2 with invalid data returns error changeset", %{user: user, task: task} do
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_task_attrs)
      assert task == Todo.get_task!(user, task.id)
    end

    test "delete_task/1 deletes the task", %{user: user, task: task} do
      assert {:ok, %Todo.List.Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(user, task.id) end
    end

    test "change_task/1 returns a task changeset", %{task: task} do
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
