defmodule TodoWeb.PageController do
  use TodoWeb, :controller

  import Plug.Conn, only: [assign: 3]

  alias Todo.Accounts
  alias Todo.Accounts.User
  alias Todo.Accounts.UserToken

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.

    conn =
      conn
      |> assign(:current_user, current_user(conn))
      |> assign(:token, maybe_generate_token(conn, params))

    render(conn, :home, layout: false)
  end

  defp current_user(%Plug.Conn{assigns: %{current_user: %User{} = user}}), do: user
  defp current_user(_), do: nil

  def maybe_generate_token(%Plug.Conn{assigns: %{current_user: %User{} = user}}, %{
        "regenerate" => "true"
      }) do
    Accounts.create_user_api_token(user)
  end

  def maybe_generate_token(%Plug.Conn{assigns: %{current_user: %User{} = user}}, _params) do
    if UserToken.user_has_token?(user, "api-token") do
      nil
    else
      Accounts.create_user_api_token(user)
    end
  end

  def maybe_generate_token(_conn, _params), do: nil
end
