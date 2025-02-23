defmodule ChatNode do
  use Application

  def start(_type, _args) do
    # Define WebSocket route
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/ws", ChatNodeWebSocket, []}
      ]}
    ])

    # Start Cowboy
    {:ok, _pid} = :cowboy.start_clear(:http,
      [{:port, 4000}],
      %{env: %{dispatch: dispatch}}
    )

    IO.puts("WebSocket server running on ws://localhost:4000/ws")
    ChatNode.Supervisor.start_link()
  end
end
