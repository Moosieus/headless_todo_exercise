defmodule TodoWeb.ListControllerTest do
  use TodoWeb.ConnCase

  import TodoFixtures
  import Todo.AccountsFixtures

  alias Todo.List

  @create_list_attrs %{
    title: "some title"
  }
  @update_list_attrs %{
    title: "some updated title"
  }
  @invalid_list_attrs %{title: nil}

  @update_task_attrs %{
    text: "some updated text",
    complete?: true
  }
  @invalid_task_attrs %{text: nil, complete?: ["fizz buzz"]}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    user =
      user_fixture(%{
        email: "foo.bar@notarealwebsite.test",
        password: "P4ssW0rd!12345",
        confirmed_at: DateTime.utc_now(:second)
      })

    {:ok, %{conn: conn, user: user}}
  end

  defp login(%{conn: %Plug.Conn{} = conn, user: user}) do
    token = Todo.Accounts.create_user_api_token(user)
    conn = put_req_header(conn, "authorization", "Bearer " <> token)

    %{conn: conn}
  end

  defp create_list(%{conn: %Plug.Conn{} = conn, user: user}) do
    list = list_fixture(user)

    %{conn: conn, list: list}
  end

  defp create_tasks(%{list: list}) do
    task1 = task_fixture(list, %{text: "Task 1"})
    task2 = task_fixture(list, %{text: "Task 2", complete?: true})
    task3 = task_fixture(list, %{text: "Task 3"})

    %{task1: task1, task2: task2, task3: task3}
  end

  describe "index" do
    setup [:login]

    test "lists all lists", %{conn: conn} do
      conn = get(conn, ~p"/api/lists")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create list" do
    setup [:login]

    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", @create_list_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", @invalid_list_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update list" do
    setup [:login, :create_list]

    test "renders list when data is valid", %{conn: conn, list: %List{id: id} = list} do
      conn = put(conn, ~p"/api/lists/#{list}", @update_list_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = put(conn, ~p"/api/lists/#{list}", @invalid_list_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete list" do
    setup [:login, :create_list]

    test "deletes chosen list", %{conn: conn, list: list} do
      conn = delete(conn, ~p"/api/lists/#{list}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/lists/#{list}") |> IO.inspect()
      end
    end
  end

  describe "create task" do
    setup [:login, :create_list]

    test "renders parent list when data is valid", %{conn: conn, list: list} do
      task_attrs = %{list_id: list.id, text: "a new task 410", complete?: true}
      conn = post(conn, ~p"/api/lists/#{list}/tasks", task_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/lists/#{list}")

      assert %{
               "id" => ^id,
               "title" => "some title",
               "tasks" => [
                 %{
                   "text" => "a new task 410",
                   "complete?" => true
                 }
               ]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = post(conn, ~p"/api/lists/#{list}/tasks", @invalid_task_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:login, :create_list, :create_tasks]

    test "renders task when data is vaild", %{conn: conn, task1: task} do
      %Todo.List.Task{
        id: id,
        list_id: list_id
      } = task

      conn = put(conn, ~p"/api/lists/#{list_id}/tasks/#{id}", @update_task_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lists/#{list_id}")

      assert %{
               "id" => ^list_id,
               "tasks" => [
                 %{
                   "id" => ^id,
                   "text" => "some updated text",
                   "complete?" => true
                 },
                 _,
                 _
               ]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task1: task} do
      %Todo.List.Task{
        id: id,
        list_id: list_id
      } = task

      conn = put(conn, ~p"/api/lists/#{list_id}/tasks/#{id}", @invalid_task_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:login, :create_list, :create_tasks]

    test "deletes chosen list", %{conn: conn, task1: task} do
      conn = delete(conn, ~p"/api/lists/#{task.list_id}/tasks/#{task}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/lists/#{task.list_id}")

      %{"tasks" => tasks} = json_response(conn, 200)["data"]

      assert length(tasks) == 2
    end
  end
end
