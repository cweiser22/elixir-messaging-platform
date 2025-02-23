defmodule ChatServerWeb.UserChannel do
  use Phoenix.Channel

  # A user joins their personal channel
  def join("user:" <> _user_id, _params, socket) do
    {:ok, socket}
  end

  # Handle incoming messages and respond with an acknowledgment
  def handle_in("new_message", %{"body" => body}, socket) do
    response = %{
      status: "received",
      received_body: body
    }

    push(socket, "message_ack", response)

    {:noreply, socket}
  end
end
