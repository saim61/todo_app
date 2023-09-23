defmodule TodoApp.Items.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoApp.Accounts.User

  schema "todos" do
    field(:date, :date, default: Date.utc_today() |> Date.add(3))
    field(:description, :string)
    field(:priority, Ecto.Enum, values: [:low, :medium, :high], default: :low)
    field(:title, :string)
    belongs_to(:user, User)
    field(:is_complete, :boolean, default: false)
    field(:uploaded_files, {:array, :string}, default: [])

    timestamps()
  end

  @fields ~w(title description priority date)a
  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, @fields ++ [:user_id, :is_complete, :uploaded_files])
    |> validate_required(@fields)
    |> validate_date()
    |> validate_length(:uploaded_files, min: 0, max: 5, message: "Cannot upload more than 5 files")
  end

  defp validate_date(changeset) do
    date = get_field(changeset, :date)

    if is_nil(date) do
      changeset
    else
      case Date.compare(date, Date.utc_today()) do
        :gt -> changeset
        :eq -> changeset
        _ -> add_error(changeset, :date, "date cannot be before today")
      end
    end
  end
end
