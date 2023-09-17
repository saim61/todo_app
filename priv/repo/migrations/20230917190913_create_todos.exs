defmodule TodoApp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :string
      add :priority, :string
      add :date, :date
      add :assigned_user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:todos, [:assigned_user])
  end
end
