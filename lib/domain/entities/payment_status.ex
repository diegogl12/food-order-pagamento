defmodule FoodOrderPagamento.Domain.Entities.PaymentStatus do
  @derive {Jason.Encoder, only: [:id, :payment_id, :status, :created_at, :current_status]}

  @type t :: %__MODULE__{
          id: String.t() | nil,
          payment_id: String.t(),
          status: String.t(),
          created_at: NaiveDateTime.t() | nil,
          current_status: boolean()
        }

  @enforce_keys [:payment_id, :status]
  defstruct [:id, :payment_id, :status, :created_at, :current_status]
end
