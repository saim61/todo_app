defmodule TodoAppWeb.TodoLive.FormComponent do
  use TodoAppWeb, :live_component

  alias TodoApp.Items
  alias TodoAppWeb.TodoLive.Shared

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage todo records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="todo-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:priority]}
          type="select"
          label="Priority"
          prompt="Choose a value"
          options={Ecto.Enum.values(TodoApp.Items.Todo, :priority)}
        />
        <.input
          field={@form[:is_complete]}
          type="select"
          label="Is this task complete?"
          prompt="Choose a value"
          options={[true, false]}
        />
        <.input field={@form[:date]} type="date" label="Date" />
        <div phx-drop-target={@uploads.external_files.ref}>
          <.live_file_input upload={@uploads.external_files} />
          <%= for entry <- @uploads.external_files.entries do  %>
            <p><%= entry.client_name %></p>
            <img class="w-6 h-6" src="https://p7.hiclipart.com/preview/212/1015/805/computer-icons-x-mark-clip-art-counter.jpg" phx-target={@myself} phx-click="cancel-upload" phx-value-ref={entry.ref}/>
            <%= for err <- upload_errors(@uploads.external_files, entry) do %>
              <p class="text-red-500 font-bold"><%= error_to_string(err) %></p>
            <% end %>
          <% end %>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Todo</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{todo: todo} = assigns, socket) do
    changeset = Items.change_todo(todo)

    {
      :ok,
      socket
      |> assign(assigns)
      |> Shared.assign_form(changeset)
      |> allow_upload(:external_files,
        accept: ~w(.pdf .docx .doc),
        auto_upload: true,
        max_entries: 5
      )
    }
  end

  @impl true
  def handle_event(
        "validate",
        %{"todo" => todo_params},
        %{assigns: %{todo: todo}} = socket
      ) do
    changeset =
      todo
      |> Items.change_todo(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, Shared.assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"todo" => todo_params},
        socket
      ) do
    files_uploaded = []

    files_uploaded =
      consume_uploaded_entries(socket, :external_files, fn %{path: path}, entry ->
        dest = Path.join("priv/static/uploads", entry.client_name)
        files_uploaded = files_uploaded ++ dest
        File.cp!(path, dest)
        {:ok, files_uploaded}
      end)

    todo_params =
      if socket.assigns.action == :edit do
        Map.put(
          todo_params,
          "uploaded_files",
          socket.assigns.todo.uploaded_files ++ files_uploaded
        )
      else
        Map.put(todo_params, "uploaded_files", files_uploaded)
      end

    Shared.save_todo(socket.assigns.action, socket, todo_params, self(), __MODULE__)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :external_files, ref)}
  end

  defp error_to_string(:too_large), do: "File size is too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files. Please upload max 5 files"
  defp error_to_string(x), do: "Some unknown error: #{x}"
end
