defmodule TodoApp.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.Items` context.
  """

  alias TodoApp.AccountsFixtures

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        date: ~D[2099-01-01],
        description: "some description",
        priority: :low,
        title: "some title",
        user_id: AccountsFixtures.user_fixture().id
      })
      |> TodoApp.Items.create_todo()

    todo
  end
end
