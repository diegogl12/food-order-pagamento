defmodule Endpoints do
  use Plug.Router
  require Logger

  plug :match

  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug :dispatch

  get "/api/health" do
    send_resp(conn, 200, "Hello... All good!")
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end

