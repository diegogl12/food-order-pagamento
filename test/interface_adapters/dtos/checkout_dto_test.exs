defmodule FoodOrderPagamento.InterfaceAdapters.DTOs.CheckoutDTOTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.InterfaceAdapters.DTOs.CheckoutDTO
  alias FoodOrderPagamento.Domain.Entities.Checkout

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "from_json/1" do
    test "successfully converts valid JSON to DTO" do
      # Arrange
      json_string = """
      {
        "order_id": "order-123",
        "amount": 100.0,
        "customer_id": "customer-456",
        "payment_method": "credit_card"
      }
      """

      # Stub Jason.decode
      stub(Jason, :decode, fn ^json_string ->
        {:ok, %{
          "order_id" => "order-123",
          "amount" => 100.0,
          "customer_id" => "customer-456",
          "payment_method" => "credit_card"
        }}
      end)

      # Act
      result = CheckoutDTO.from_json(json_string)

      # Assert
      assert {:ok, %CheckoutDTO{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }} = result
    end

    test "returns error when JSON is invalid" do
      # Arrange
      invalid_json = "{invalid_json:"

      # Stub Jason.decode
      stub(Jason, :decode, fn ^invalid_json ->
        {:error, %Jason.DecodeError{position: 1, data: invalid_json}}
      end)

      # Act
      result = CheckoutDTO.from_json(invalid_json)

      # Assert
      assert {:error, %Jason.DecodeError{}} = result
    end
  end

  describe "from_map/1" do
    test "successfully converts valid map to DTO" do
      # Arrange
      valid_map = %{
        "order_id" => "order-123",
        "amount" => 100.0,
        "customer_id" => "customer-456",
        "payment_method" => "credit_card"
      }

      # Act
      result = CheckoutDTO.from_map(valid_map)

      # Assert
      assert {:ok, %CheckoutDTO{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }} = result
    end
  end

  describe "to_domain/1" do
    test "successfully converts DTO to domain entity" do
      # Arrange
      dto = %CheckoutDTO{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      expected_checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      # Stub Checkout.new
      stub(Checkout, :new, fn params when is_map(params) ->
        {:ok, expected_checkout}
      end)

      # Act
      result = CheckoutDTO.to_domain(dto)

      # Assert
      assert {:ok, ^expected_checkout} = result
    end

    test "returns error when domain entity creation fails" do
      # Arrange
      dto = %CheckoutDTO{
        order_id: "order-123",
        amount: -100.0, # invalid amount
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      # Stub Checkout.new
      stub(Checkout, :new, fn _params ->
        {:error, "amount must be positive"}
      end)

      # Act
      result = CheckoutDTO.to_domain(dto)

      # Assert
      assert {:error, "amount must be positive"} = result
    end
  end
end
