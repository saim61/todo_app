defmodule TodoApp.ItemsTest do
  use TodoApp.DataCase

  alias TodoApp.Items
  alias TodoApp.Repo

  describe "todos" do
    alias TodoApp.Items.Todo

    import TodoApp.ItemsFixtures

    @invalid_attrs %{date: nil, description: nil, priority: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture() |> Repo.preload((:user))
      assert Items.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture() |> Repo.preload(:user)
      assert Items.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{date: ~D[2099-01-01], description: "some description", priority: :low, title: "some title"}

      assert {:ok, %Todo{} = todo} = Items.create_todo(valid_attrs)
      assert todo.date == ~D[2099-01-01]
      assert todo.description == "some description"
      assert todo.priority == :low
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{date: ~D[2099-02-02], description: "some updated description", priority: :low, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = Items.update_todo(todo, update_attrs)
      assert todo.date == ~D[2099-02-02]
      assert todo.description == "some updated description"
      assert todo.priority == :low
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture() |> Repo.preload((:user))
      assert {:error, %Ecto.Changeset{}} = Items.update_todo(todo, @invalid_attrs)
      assert todo == Items.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture() |> Repo.preload((:user))
      assert {:ok, %Todo{}} = Items.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Items.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture() |> Repo.preload((:user))
      assert %Ecto.Changeset{} = Items.change_todo(todo)
    end
  end
end
