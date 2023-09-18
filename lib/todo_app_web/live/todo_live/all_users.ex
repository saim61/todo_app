defmodule TodoAppWeb.TodoLive.AllUsers do
  use TodoAppWeb, :live_view

  alias TodoApp.{Items, Items.Todo, Accounts}

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> stream(:todos, Items.list_todos())
     |> assign(current_user: current_user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(%{assigns: %{current_user: current_user}} = socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{user_id: current_user.id})
    |> assign(current_user: socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_info({TodoAppWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Items.get_todo!(id)
    {:ok, _} = Items.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end
end
