defmodule FoodOrderPagamento.InterfaceAdapters.DTOs.MercadopagoResponseDTO do
  defstruct [
    :payment_id,
    :transaction_amount,
    :description,
    :payment_date,
    :payment_method,
    :created_at
  ]

  alias FoodOrderPagamento.Domain.Entities.Payment

  @type t :: %__MODULE__{
          payment_id: String.t(),
          transaction_amount: float(),
          description: String.t(),
          payment_date: NaiveDateTime.t(),
          payment_method: String.t(),
          created_at: NaiveDateTime.t()
        }

  def to_payment(dto, %{order_id: order_id}) do
    %Payment{
      order_id: order_id,
      external_id: dto.payment_id,
      amount: dto.transaction_amount,
      payment_method: dto.payment_method,
      payment_date: dto.payment_date,
      created_at: dto.created_at
    }
  end
end
