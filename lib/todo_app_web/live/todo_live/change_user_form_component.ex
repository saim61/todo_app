defmodule TodoAppWeb.TodoLive.ChangeUserFormComponent do
  use TodoAppWeb, :live_component

  alias TodoApp.{Items, Accounts}
  alias TodoAppWeb.TodoLive.Shared

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to change the users of your todo records.</:subtitle>
      </.header>

      <.list>
        <:item title="Title"><%= @todo.title %></:item>
        <:item title="Currently assigned to"><%= @todo.user.first_name %></:item>
      </.list>

      <.simple_form
        for={@form}
        id="todo-form-change-user"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:selected_user]}
          type="select"
          label="Assign to?"
          prompt="Choose a value"
          options={Enum.map(@all_users, & &1.email)}
        />
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
  def handle_event("validate", _params, socket), do: {:noreply, socket}

  def handle_event(
        "save",
        %{"todo" => %{"selected_user" => selected_user}},
        socket
      ) do
    selected_user_id = Accounts.get_user_by_email(selected_user).id
    Shared.save_todo(:edit, socket, %{user_id: selected_user_id}, self(), __MODULE__)
  end
end
