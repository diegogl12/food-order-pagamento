defmodule FoodOrderPagamento.UseCases.UpdatePaymentStatusTest do
  use ExUnit.Case, async: true

  alias FoodOrderPagamento.UseCases.UpdatePaymentStatus
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  describe "execute/4" do
    test "successfully updates payment status" do
      # Arrange
      payment_status_dto = %{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      new_payment_status = %PaymentStatus{
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }

      Mox.expect(PaymentRepositoryMock, :find_by, fn [external_id: "ext-123"] ->
        {:ok, payment}
      end)

      Mox.expect(PaymentStatusRepositoryMock, :create, fn status ->
        assert status.payment_id == payment.id
        assert status.status == "Pagamento Aprovado"
        {:ok, new_payment_status}
      end)

      Mox.expect(OrderGatewayMock, :update_payment_status, fn ^payment, ^new_payment_status ->
        :ok
      end)

      # Act
      result = UpdatePaymentStatus.execute(
        payment_status_dto,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock,
        OrderGatewayMock
      )

      # Assert
      assert {:ok, ^new_payment_status} = result
    end

    test "returns error when payment is not found" do
      # Arrange
      payment_status_dto = %{
        payment_id: "non-existent-id",
        status: "Pagamento Aprovado"
      }

      Mox.expect(PaymentRepositoryMock, :find_by, fn [external_id: "non-existent-id"] ->
        {:error, :not_found}
      end)

      # Act
      result = UpdatePaymentStatus.execute(
        payment_status_dto,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock,
        OrderGatewayMock
      )

      # Assert
      assert {:error, :not_found} = result
    end

    test "returns error when payment status repository fails" do
      # Arrange
      payment_status_dto = %{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      Mox.expect(PaymentRepositoryMock, :find_by, fn [external_id: "ext-123"] ->
        {:ok, payment}
      end)

      Mox.expect(PaymentStatusRepositoryMock, :create, fn status ->
        assert status.payment_id == payment.id
        {:error, "Database error"}
      end)

      # Act
      result = UpdatePaymentStatus.execute(
        payment_status_dto,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock,
        OrderGatewayMock
      )

      # Assert
      assert {:error, "Database error"} = result
    end

    test "returns error when order gateway fails" do
      # Arrange
      payment_status_dto = %{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      new_payment_status = %PaymentStatus{
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }

      Mox.expect(PaymentRepositoryMock, :find_by, fn [external_id: "ext-123"] ->
        {:ok, payment}
      end)

      Mox.expect(PaymentStatusRepositoryMock, :create, fn status ->
        assert status.payment_id == payment.id
        {:ok, new_payment_status}
      end)

      Mox.expect(OrderGatewayMock, :update_payment_status, fn ^payment, ^new_payment_status ->
        {:error, "Communication error"}
      end)

      # Act
      result = UpdatePaymentStatus.execute(
        payment_status_dto,
        PaymentRepositoryMock,
        PaymentStatusRepositoryMock,
        OrderGatewayMock
      )

      # Assert
      assert {:error, "Communication error"} = result
    end
  end
end
