defmodule SocksWeb.RoomChannel do
  use Phoenix.Channel

  @doc """
  This is the public topic, everyone can read messages here
  """
  @impl true
  def join("lobby", _msg, socket) do
    # after 30 seconds send a "magical" 'disconnect' message that will
    # disconnect the user and clear all messages from the UI
    :timer.send_after(:timer.minutes(3), :disconnect_user)
    {:ok, socket}
  end

  @doc """
  This is the private topic for the user
  """
  @impl true
  def join("private:" <> user_id, _msg, %{assigns: %{user_id: user_id}} = socket) do
    {:ok, socket}
  end

  # this handles the message on the public channel, but redirects it to the
  # private channel for the recipient
  @impl true
  def handle_in("send_public_message", %{"message" => message}, socket) do
    broadcast(socket, "message", %{"message" => message})
    {:noreply, socket}
  end

  # this handles the message on the public channel, but redirects it to the
  # private channel for the recipient
  @impl true
  def handle_in(
        "send_private_message",
        %{"recipientId" => recipient_id, "message" => message},
        socket
      ) do
    SocksWeb.Endpoint.broadcast!("private:#{recipient_id}", "message", %{"message" => message})
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
