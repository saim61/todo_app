defmodule TodoApp.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.Items` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        date: ~D[2023-09-16],
        description: "some description",
        priority: :"low,medium,high",
        title: "some title"
      })
      |> TodoApp.Items.create_todo()

    todo
  end
end
