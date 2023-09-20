defmodule TodoApp.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias TodoApp.{Repo, Comment}

  @doc """
  Get a single comment
  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Get all comments on a Todo.
  """
  def get_all_comments(todo_id) do
    from(c in Comment, where: c.todo_id == ^todo_id)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Create comment on a Todo.
  """
  def create_comment(comment) do
    %Comment{}
    |> Comment.changeset(comment)
    |> Repo.insert()
  end

  @doc """
  Deletes a comment.
  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end
end
