defmodule TodoAppWeb.TodoLiveTest do
  use TodoAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import TodoApp.ItemsFixtures

  alias alias TodoApp.Repo

  defp create_todo(_) do
    todo = todo_fixture() |> Repo.preload(:user)
    %{todo: todo, user: todo.user}
  end

  describe "Index" do
    setup [:create_todo]

    test "lists all todos", %{conn: conn, todo: todo} do
      conn = log_in_user(conn, todo.user)
      {:ok, _index_live, html} = live(conn, ~p"/todos")

      assert html =~ "Listing Todos"
      assert "some description" =~ todo.description
    end

    test "deletes todo in listing", %{conn: conn, todo: todo} do
      conn = log_in_user(conn, todo.user)
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("#todos-#{todo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todos-#{todo.id}")
    end
  end

  describe "Show" do
    setup [:create_todo]

    test "displays todo", %{conn: conn, todo: todo} do
      conn = log_in_user(conn, todo.user)
      {:ok, _show_live, html} = live(conn, ~p"/todos/#{todo}")

      assert html =~ "Show Todo"
      assert html =~ todo.description
    end
  end
end
