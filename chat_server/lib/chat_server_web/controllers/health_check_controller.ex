defmodule ChatServerWeb.HealthCheckController do
  use ChatServerWeb, :controller

  def check(conn, _params) do
    json(conn, %{status: "awesome it works"})
  end
end
