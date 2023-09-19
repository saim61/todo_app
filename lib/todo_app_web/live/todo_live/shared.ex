defmodule TodoAppWeb.TodoLive.Shared do
  use Phoenix.Component
  import Phoenix.LiveView

  alias TodoApp.Items

  def save_todo(:new, %{assigns: %{current_user: current_user}} = socket, todo_params, id, module) do
    case Items.create_todo(Map.put(todo_params, "user_id", current_user.id)) do
      {:ok, todo} ->
        notify_parent(id, module, {:saved, todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> redirect(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def save_todo(:edit, socket, todo_params, id, module) do
    case Items.update_todo(socket.assigns.todo, todo_params) do
      {:ok, todo} ->
        notify_parent(id, module, {:saved, todo})

        {:noreply,
         socket
         |> put_flash(:info, "Todo updated successfully")
         |> redirect(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def get_file_extension(filename) do
    Regex.run(~r/\.[A-Za-z]+/, filename, capture: :first) |> hd()
  end

  defp notify_parent(id, module, msg), do: send(id, {module, msg})
end
