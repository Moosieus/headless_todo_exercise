defmodule Todo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Todo.Accounts.register_user()

    user
  end

  def confirm_user(%Todo.Accounts.User{} = user) do
    Todo.Accounts.User.changeset(user, %{
      confirmed_at: DateTime.utc_now(:second)
    })
    |> Todo.Repo.insert_or_update!()
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
