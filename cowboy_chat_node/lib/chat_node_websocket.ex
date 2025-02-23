defmodule ChatNodeWebSocket do
  @behaviour :cowboy_websocket

  # Called when a client connects
  def init(request, _state) do
    {:cowboy_websocket, request, %{}}
  end

  # Called when the connection is established
  def websocket_init(state) do
    IO.puts("WebSocket connection established")
    {:ok, state}
  end

  # Called when a message is received from the client
  def websocket_handle({:text, message}, state) do
    IO.puts("Received: #{message}")
    {:reply, {:text, "Echo: #{message}"}, state}
  end

  def websocket_handle(_other, state) do
    {:ok, state}
  end

  # Called when the process receives a message
  def websocket_info(_info, state) do
    {:ok, state}
  end

  # Called when the connection is closed
  def terminate(_reason, _state) do
    IO.puts("WebSocket closed")
    :ok
  end
end
