defmodule FoodOrderPagamento.Domain.Entities.Payment do
  @derive {Jason.Encoder, only: [:id, :order_id, :amount, :payment_date, :payment_method, :created_at, :external_id]}
  defstruct [:id, :order_id, :amount, :payment_date, :payment_method, :created_at, :external_id]

  @type t :: %__MODULE__{
          id: String.t(),
          order_id: String.t(),
          external_id: String.t(),
          amount: float() | nil,
          payment_date: NaiveDateTime.t() | nil,
          payment_method: String.t() | nil,
          created_at: NaiveDateTime.t() | nil
        }

  def new(attrs) do
    payment =
      struct(
        __MODULE__,
        Map.merge(attrs, %{
          created_at: NaiveDateTime.utc_now()
        })
      )

    {:ok, payment}
  end
end

# payment = %FoodOrderPagamento.Domain.Entities.Payment{order_id: "2010a7da-230c-4185-8b91-672cf733c49d", amount: 99.99, payment_date: ~N[2024-03-20 10:00:00], payment_method: "credit_card", status: nil, created_at: nil}
