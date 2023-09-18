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

    {:ok,
     socket
     |> assign(assigns)
     |> Shared.assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset =
      socket.assigns.todo
      |> Items.change_todo(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, Shared.assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"todo" => todo_params},
        socket
      ) do
    Shared.save_todo(socket.assigns.action, socket, todo_params, self(), __MODULE__)
  end
end
