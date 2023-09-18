defmodule TodoApp.Repo.Migrations.NameForUser do
  use Ecto.Migration

  @table :users
  def up do
    alter table(@table) do
      add(:first_name, :string)
      add(:last_name, :string)
    end
  end

  def down do
    alter table(@table) do
      remove(:first_name)
      remove(:last_name)
    end
  end
end
