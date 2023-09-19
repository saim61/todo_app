defmodule TodoApp.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoApp.{Items.Todo, Accounts.User}

  schema "comments" do
    field :body, :string
    belongs_to :user, User
    belongs_to :todo, Todo

    timestamps()
  end

  @fields ~w(body user_id todo_id)a
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
