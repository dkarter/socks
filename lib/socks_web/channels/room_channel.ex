defmodule SocksWeb.RoomChannel do
  use Phoenix.Channel

  @impl true
  def join("lobby", _msg, socket) do
    :timer.send_interval(:timer.seconds(5), :broadcast_public)
    :timer.send_after(:timer.seconds(30), :disconnect_user)
    {:ok, socket}
  end

  @impl true
  def join("private:" <> _user_id, _msg, socket) do
    :timer.send_interval(:timer.seconds(5), :broadcast_private)
    {:ok, socket}
  end

  @impl true
  def handle_info(:broadcast_public, socket) do
    message = %{"time" => DateTime.utc_now() |> DateTime.to_iso8601()}
    broadcast(socket, "message", message)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:broadcast_private, socket) do
    user_id = socket.assigns.user_id
    IO.inspect("::::::: sending private broadcast to private:#{user_id}")

    broadcast(socket, "message", %{"user_id" => user_id})

    {:noreply, socket}
  end

  @impl true
  def handle_info(:disconnect_user, socket) do
    user_id = socket.assigns.user_id
    IO.inspect("::::::: sending disconnect to user_socket:#{user_id}")

    SocksWeb.Endpoint.broadcast("user_socket:#{user_id}", "disconnect", %{})
    {:noreply, socket}
  end
end
