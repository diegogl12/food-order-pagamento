defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.DTOs.CheckoutDTO do
  alias FoodOrderPagamento.Domain.Entities.Checkout

  defstruct [:order_id, :amount, :customer_id, :payment_method]

  @type t :: %__MODULE__{
          order_id: String.t(),
          amount: float(),
          customer_id: String.t(),
          payment_method: String.t()
        }

  def to_domain(%__MODULE__{} = dto) do
    Checkout.new(%{
      order_id: dto.order_id,
      amount: dto.amount,
      customer_id: dto.customer_id,
      payment_method: dto.payment_method
    })
  end

  def from_json(json) do
    with {:ok, data} <- Jason.decode(json),
         {:ok, dto} <- from_map(data) do
      {:ok, dto}
    end
  end

  def from_map(map) when is_map(map) do
    dto = struct(__MODULE__, map)
    {:ok, dto}
  rescue
    _ -> {:error, "Invalid checkout data"}
  end
end
