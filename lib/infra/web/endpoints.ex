defmodule FoodOrderPagamento.Infra.Web.Endpoints do
  use Plug.Router
  require Logger

  alias FoodOrderPagamento.Infra.Web.Controllers.PaymentController

  plug(:match)

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)

  plug(:dispatch)

  get "/api/health" do
    send_resp(conn, 200, "Hello... All good!")
  end

  put "/api/payment/status" do
    case PaymentController.update_payment_status(conn.body_params) do
      {:ok, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: "Payment status updated"}))

      {:error, error} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{message: "Error updating payment status: #{inspect(error)}"})
        )
    end
  end

  get "/api/payments/:id" do
    case PaymentController.get_payment(conn.params["id"]) do
      {:ok, payment} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(payment))

      {:error, error} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{message: "Error getting payment: #{inspect(error)}"}))
    end
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end
