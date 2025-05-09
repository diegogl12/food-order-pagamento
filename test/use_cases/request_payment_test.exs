defmodule FoodOrderPagamento.UseCases.RequestPaymentTest do
  use ExUnit.Case, async: true

  alias FoodOrderPagamento.UseCases.RequestPayment
  alias FoodOrderPagamento.Domain.Entities.Checkout
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  describe "execute/4" do
    test "successfully processes payment" do
      # Arrange
      checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      payment_status = %PaymentStatus{
        payment_id: "payment-123",
        status: "Pagamento Pendente"
      }

      Mox.expect(PaymentGatewayMock, :perform_payment, fn ^checkout ->
        {:ok, payment}
      end)

      Mox.expect(PaymentRepositoryMock, :create, fn ^payment ->
        {:ok, payment}
      end)

      Mox.expect(PaymentStatusRepositoryMock, :create, fn status ->
        assert status.payment_id == payment.id
        assert status.status == "Pagamento Pendente"
        {:ok, payment_status}
      end)

      # Act
      result = RequestPayment.execute(
        checkout,
        PaymentGatewayMock,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock
      )

      # Assert
      assert {:ok, ^payment} = result
    end

    test "returns error when payment provider fails" do
      # Arrange
      checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      Mox.expect(PaymentGatewayMock, :perform_payment, fn ^checkout ->
        {:error, "Payment provider error"}
      end)

      # Act
      result = RequestPayment.execute(
        checkout,
        PaymentGatewayMock,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock
      )

      # Assert
      assert {:error, "Payment provider error"} = result
    end

    test "returns error when payment repository fails" do
      # Arrange
      checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      Mox.expect(PaymentGatewayMock, :perform_payment, fn ^checkout ->
        {:ok, payment}
      end)

      Mox.expect(PaymentRepositoryMock, :create, fn ^payment ->
        {:error, "Database error"}
      end)

      # Act
      result = RequestPayment.execute(
        checkout,
        PaymentGatewayMock,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock
      )

      # Assert
      assert {:error, "Database error"} = result
    end

    test "returns error when payment status repository fails" do
      # Arrange
      checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      Mox.expect(PaymentGatewayMock, :perform_payment, fn ^checkout ->
        {:ok, payment}
      end)

      Mox.expect(PaymentRepositoryMock, :create, fn ^payment ->
        {:ok, payment}
      end)

      Mox.expect(PaymentStatusRepositoryMock, :create, fn status ->
        assert status.payment_id == payment.id
        {:error, "Database error"}
      end)

      # Act
      result = RequestPayment.execute(
        checkout,
        PaymentGatewayMock,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock
      )

      # Assert
      assert {:error, "Database error"} = result
    end
  end
end
