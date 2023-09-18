defmodule TodoApp.Repo.Migrations.TodoItemsCompleteStatus do
  use Ecto.Migration

  @table :todos
  def up do
    alter table(@table) do
      add(:is_complete, :boolean, default: false, null: false)
    end
  end

  def down do
    alter table(@table) do
      remove(:is_complete)
    end
  end
end
