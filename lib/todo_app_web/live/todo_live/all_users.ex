defmodule TodoAppWeb.TodoLive.AllUsers do
  use TodoAppWeb, :live_view

  import TodoAppWeb.TodoLive.Shared,
    only: [sort_via_priority_component: 1, sort_todos_by_priority: 2]

  alias TodoApp.{Items, Items, Accounts}

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {
      :ok,
      socket
      |> stream(:todos, Items.list_todos())
      |> assign(current_user: current_user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  defp apply_action(socket, :change_user, %{"id" => id}) do
    socket
    |> assign(:page_title, "Viewing Todo")
    |> assign(:todo, Items.get_todo!(id))
    |> assign(all_users: Accounts.get_all_users())
  end

  @impl true
  def handle_info({TodoAppWeb.TodoLive.ChangeUserFormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event(
        "sort_via_priority",
        %{"priority" => priority},
        socket
      ) do
    {:noreply, sort_todos_by_priority(socket, priority)}
  end
end
