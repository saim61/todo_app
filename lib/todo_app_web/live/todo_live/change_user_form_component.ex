defmodule TodoAppWeb.TodoLive.ChangeUserFormComponent do
  use TodoAppWeb, :live_component

  alias TodoApp.{Items, Accounts}

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
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "save",
        %{"todo" => %{"selected_user" => selected_user}},
        socket
      ) do
    selected_user_id = Accounts.get_user_by_email(selected_user).id
    save_todo(socket, socket.assigns.action, %{user_id: selected_user_id})
  end

  defp save_todo(socket, :change_user, todo_params) do
    case Items.update_todo(socket.assigns.todo, todo_params) do
      {:ok, todo} ->
        notify_parent({:saved, todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo updated successfully")
         |> redirect(to: "/todos/all")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
