defmodule ChatServer do
  use Application

  def start(_type, _args) do
    children = [
      {Bandit, plug: ChatServer.Router, scheme: :http, port: 4000}
    ]

    opts = [strategy: :one_for_one, name: ChatServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end