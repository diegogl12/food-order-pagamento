defmodule FoodOrderPagamento.Domain.Entities.Payment do
  defstruct [:payment_id, :order_id, :amount, :status, :created_at]

  @type t :: %__MODULE__{
          payment_id: String.t(),
          order_id: String.t(),
          amount: float(),
          status: String.t(),
          created_at: DateTime.t()
        }

  def new(attrs) do
    payment =
      struct(
        __MODULE__,
        Map.merge(attrs, %{
          created_at: DateTime.utc_now()
        })
      )

    {:ok, payment}
  end
end
