defmodule FoodOrderPagamento.InterfaceAdapters.DTOs.PaymentStatusUpdateDTOTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.InterfaceAdapters.DTOs.PaymentStatusUpdateDTO
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "from_map/1" do
    test "successfully converts valid map to DTO" do
      # Arrange
      valid_map = %{
        "payment_id" => "ext-123",
        "status" => "Pagamento Aprovado"
      }

      # Act
      result = PaymentStatusUpdateDTO.from_map(valid_map)

      # Assert
      assert {:ok, %PaymentStatusUpdateDTO{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }} = result
    end
  end

  describe "to_domain/1" do
    test "successfully converts DTO to domain entity" do
      # Arrange
      dto = %PaymentStatusUpdateDTO{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }

      expected_payment_status = %PaymentStatus{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }

      # Act
      result = PaymentStatusUpdateDTO.to_domain(dto)

      # Assert
      assert {:ok, %PaymentStatus{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }} = result
    end
  end
end
