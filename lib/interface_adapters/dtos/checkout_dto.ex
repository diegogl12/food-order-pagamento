defmodule FoodOrderPagamento.InterfaceAdapters.DTOs.CheckoutDTO do
  alias FoodOrderPagamento.Domain.Entities.Checkout

  defstruct [:order_id, :amount, :customer_id, :payment_method]

  @type t :: %__MODULE__{
          order_id: String.t(),
          amount: float(),
          customer_id: String.t() | nil,
          payment_method: String.t() | nil
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
    map_with_atoms =
      map
      |> Enum.map(fn {key, value} ->
        {String.to_existing_atom(key), value}
      end)
      |> Map.new()

    dto = %__MODULE__{
      order_id: map_with_atoms |> Map.get(:NumeroPedido) |> handle_value(),
      amount: Map.get(map_with_atoms, :Preco) |> handle_value(),
      payment_method: Map.get(map_with_atoms, :MetodoPagamento) |> handle_value()
    }

    {:ok, dto}
  rescue
    ArgumentError -> {:error, "Invalid checkout data - unknown fields"}
    _ -> {:error, "Invalid checkout data"}
  end

  defp handle_value(value) when is_binary(value), do: value
  defp handle_value(value) when is_integer(value), do: Integer.to_string(value)
  defp handle_value(_), do: nil
end
