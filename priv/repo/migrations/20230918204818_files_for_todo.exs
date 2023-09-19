defmodule TodoApp.Repo.Migrations.FilesForTodo do
  use Ecto.Migration

  @table :todos
  def up do
    alter table(@table) do
      add :uploaded_files, {:array, :string}, default: [], null: false
    end
  end

  def down do
    alter table(@table) do
      remove(:uploaded_files)
    end
  end
end
