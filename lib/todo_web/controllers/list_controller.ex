defmodule TodoWeb.ListController do
  use TodoWeb, :controller

  action_fallback TodoWeb.FallbackController

  def index(conn, _params) do
    user = current_user!(conn)

    lists = Todo.list_lists(user)
    render(conn, :index, lists: lists)
  end

  def create(conn, %{"list" => list_params}) do
    user = current_user!(conn)

    with {:ok, %Todo.List{} = list} <- Todo.create_list(user, list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lists/#{list}")
      |> render(:show, list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    user = current_user!(conn)

    list = Todo.get_list!(user, id)
    render(conn, :show, list: list)
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    user = current_user!(conn)

    list = Todo.get_list!(user, id)

    with {:ok, %Todo.List{} = list} <- Todo.update_list(list, list_params) do
      render(conn, :show, list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = current_user!(conn)

    list = Todo.get_list!(user, id)

    with {:ok, %Todo.List{}} <- Todo.delete_list(list) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_task(conn, %{"list_id" => list_id, "task" => task_params}) do
    user = current_user!(conn)

    list = Todo.get_list!(user, list_id)

    with {:ok, %Todo.List.Task{} = task} <- Todo.create_task(list, task_params) do
      list = Todo.get_list!(user, task.list_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lists/#{list}")
      |> render(:show, list: list)
    end
  end

  def update_task(conn, %{"id" => id, "task" => task_params}) do
    user = current_user!(conn)

    task = Todo.get_task!(user, id)

    with {:ok, %Todo.List{} = list} <- Todo.update_task(task, task_params) do
      render(conn, :show, list: list)
    end
  end

  def delete_task(conn, %{"id" => id}) do
    user = current_user!(conn)

    task = Todo.get_task!(user, id)

    with {:ok, %Todo.List.Task{}} <- Todo.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end

  defp current_user!(%Plug.Conn{} = conn) do
    %Plug.Conn{
      assigns: %{
        current_user: user
      }
    } = conn

    user || raise ":current_user required in plug assigns"
  end
end
