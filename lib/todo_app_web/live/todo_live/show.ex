defmodule TodoAppWeb.TodoLive.Show do
  alias TodoApp.Accounts
  use TodoAppWeb, :live_view

  alias TodoApp.{Items, Accounts}

  @impl true
  def mount(%{"id" => id}, %{"user_token" => user_token}, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:todo, Items.get_todo!(id))
    }
  end

  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"
end
