defmodule TodoApp.Items.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :date, :date
    field :description, :string
    field :priority, Ecto.Enum, values: [:low, :medium, :high]
    field :title, :string
    field :assigned_user, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :priority, :date, :assigned_user])
    |> validate_required([:title, :description, :priority, :date])
  end
end
