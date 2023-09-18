defmodule TodoApp.Items.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field(:date, :date)
    field(:description, :string)
    field(:priority, Ecto.Enum, values: [:low, :medium, :high], default: :low)
    field(:title, :string)
    field(:assigned_user, :id)
    field(:is_complete, :boolean, default: false)

    timestamps()
  end

  @fields ~w(title description priority date)a
  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, @fields ++ [:assigned_user, :is_complete])
    |> validate_required(@fields)
    |> validate_date()
  end

  defp validate_date(changeset) do
    date = get_field(changeset, :date)

    if is_nil(date) do
      changeset
    else
      case Date.compare(date, Date.utc_today()) do
        :gt -> changeset
        :eq -> changeset
        _ -> add_error(changeset, :date, "cant be before current date")
      end
    end
  end
end
