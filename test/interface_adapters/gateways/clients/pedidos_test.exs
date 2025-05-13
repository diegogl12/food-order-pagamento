defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.PedidosTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Pedidos
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "update_payment_status/2" do
    test "successfully updates payment status" do
      # Arrange
      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_method: "credit_card",
        payment_date: ~N[2025-01-01 00:00:00]
      }

      payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: 0,
        created_at: ~N[2025-01-01 00:00:00]
      }

      mock_client = make_ref()
      stub(Tesla, :client, fn _middleware -> mock_client end)

      # Stub Tesla.put without pattern matching on the payload
      stub(Tesla, :put, fn client, path, payload ->
        assert client == mock_client
        assert path == "/Pedido/AtualizarStatuspagamento"
        assert payload == %{
          numeroPedido: payment.order_id,
          status: payment_status.status
        }

        {:ok, %{status: 200, body: %{message: "Status updated successfully"}}}
      end)

      # Act
      result = Pedidos.update_payment_status(payment, payment_status)

      # Assert
      assert :ok = result
    end

    test "returns error when API returns error response" do
      # Arrange
      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_method: "credit_card",
        payment_date: ~N[2025-01-01 00:00:00]
      }

      payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: 0,
        created_at: ~N[2025-01-01 00:00:00]
      }

      mock_client = make_ref()
      stub(Tesla, :client, fn _middleware -> mock_client end)

      error_response = %{error: "Order not found"}
      # Stub Tesla.put without pattern matching on the payload
      stub(Tesla, :put, fn client, path, payload ->
        assert client == mock_client
        assert path == "/Pedido/AtualizarStatuspagamento"
        assert payload == %{
          numeroPedido: payment.order_id,
          status: payment_status.status
        }

        {:ok, %{status: 404, body: error_response}}
      end)

      # Act
      result = Pedidos.update_payment_status(payment, payment_status)

      # Assert
      assert {:error, {404, ^error_response}} = result
    end

    test "returns error when API request fails" do
      # Arrange
      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_method: "credit_card",
        payment_date: ~N[2025-01-01 00:00:00]
      }

      payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: 0,
        created_at: ~N[2025-01-01 00:00:00]
      }

      mock_client = make_ref()
      stub(Tesla, :client, fn _middleware -> mock_client end)

      # Stub Tesla.put without pattern matching on the payload
      stub(Tesla, :put, fn client, path, payload ->
        assert client == mock_client
        assert path == "/Pedido/AtualizarStatuspagamento"
        assert payload == %{
          numeroPedido: payment.order_id,
          status: payment_status.status
        }

        {:error, :connection_refused}
      end)

      # Act
      result = Pedidos.update_payment_status(payment, payment_status)

      # Assert
      assert {:error, :connection_refused} = result
    end
  end
end
