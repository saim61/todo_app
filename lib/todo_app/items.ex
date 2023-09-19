defmodule TodoApp.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias TodoApp.Repo

  alias TodoApp.Items.Todo

  @doc """
  Returns the list of todos of all users.
  """
  def list_todos() do
    Repo.all(Todo)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of todos of current user.
  """
  def list_todos_of_user(current_user) do
    from(t in Todo,
      where: ^current_user.id == t.user_id
    )
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Returns the todos for all users by priority
  """
  def list_all_todos_by_priority(priority) do
    from(t in Todo)
    |> where([t], t.priority == ^priority)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Returns the todos for current user by priority
  """
  def list_user_todos_by_priority(priority, user_id) do
    from(t in Todo)
    |> where([t], t.priority == ^priority)
    |> where([t], t.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id) |> Repo.preload(:user)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
