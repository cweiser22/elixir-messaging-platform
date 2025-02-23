defmodule ChatServerWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "user:*", ChatServerWeb.UserChannel  # Each user gets their own channel

  transport :websocket, Phoenix.Transports.WebSocket

  # Accepts all connections (no auth for now)
  def connect(_params, socket, _connect_info), do: {:ok, socket}

  # No unique identifier for now
  def id(_socket), do: nil
end
