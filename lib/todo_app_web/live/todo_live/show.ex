defmodule TodoAppWeb.TodoLive.Show do
  alias TodoApp.Accounts
  use TodoAppWeb, :live_view

  alias TodoApp.{Items, Accounts, Comment, Comments}

  @impl true
  def mount(%{"id" => id}, %{"user_token" => user_token}, socket) do
    TodoAppWeb.Endpoint.subscribe(topic(id))

    current_user = Accounts.get_user_by_session_token(user_token)
    todo = Items.get_todo!(id)

    default_changeset =
      Comment.changeset(%Comment{}, %{user_id: current_user.id, todo_id: todo.id})

    {
      :ok,
      socket
      |> assign(:current_user, current_user)
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:todo, todo)
      |> assign(:default_changeset, default_changeset)
      |> assign(:comment_changeset, default_changeset)
      |> assign(:comments, Comments.get_all_comments(todo.id))
    }
  end

  @impl true
  def handle_event(
        "post_comment",
        %{"comment" => comment_params},
        socket
      ) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        default_state = defaults(socket)
        TodoAppWeb.Endpoint.broadcast_from(self(), topic(comment.todo_id), "refresh_comments", default_state)
        send(self(), "load_comments")
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, comment_changeset: changeset)}
    end
  end

  @impl true
  def handle_event("delete_comment", %{"comment_id" => comment_id}, socket) do
    comment = Comments.get_comment!(comment_id)
    {:ok, _} = Comments.delete_comment(comment)
    default_state = defaults(socket)
    TodoAppWeb.Endpoint.broadcast_from(self(), topic(comment.todo_id), "refresh_comments", default_state)
    send(self(), "refresh_comments")
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "refresh_comments", payload: payload}, socket) do
    {:noreply, assign(socket, payload)}
  end

  @impl true
  def handle_info("load_comments", socket) do
    default_state = defaults(socket)
    {:noreply, assign(socket, default_state)}
  end

  @impl true
  def handle_info("refresh_comments", socket) do
    default_state = defaults(socket)

    {:noreply,
     socket |> assign(default_state) |> put_flash(:info, "Comment deleted successfully")}
  end

  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"
  defp topic(todo_id), do: "chat:#{todo_id}"

  defp defaults(%{assigns: %{default_changeset: default_changeset, todo: todo}}) do
    %{
      comment_changeset: default_changeset,
      comments: Comments.get_all_comments(todo.id)
    }
  end
end
