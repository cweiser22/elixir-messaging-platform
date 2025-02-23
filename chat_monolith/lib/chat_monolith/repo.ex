defmodule ChatMonolith.Repo do
  use Ecto.Repo,
    otp_app: :chat_monolith,
    adapter: Ecto.Adapters.Postgres
end
