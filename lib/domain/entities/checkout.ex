defmodule FoodOrderPagamento.Domain.Entities.Checkout do
  @derive {Jason.Encoder, only: [:id, :order_id, :amount, :customer_id, :payment_method]}
  defstruct [:id, :order_id, :amount, :customer_id, :payment_method]

  @type t :: %__MODULE__{
          id: String.t(),
          order_id: String.t(),
          amount: String.t(),
          customer_id: String.t(),
          payment_method: String.t()
        }

  def new(attrs) do
    checkout = struct(__MODULE__, attrs)
    validate(checkout)
  end

  defp validate(%__MODULE__{} = checkout) do
    cond do
      is_nil(checkout.order_id) -> {:error, "order_id is required"}
      is_nil(checkout.amount) -> {:error, "amount is required"}
      checkout.amount < 0 -> {:error, "amount must be positive"}
      true -> {:ok, checkout}
    end
  end
end
