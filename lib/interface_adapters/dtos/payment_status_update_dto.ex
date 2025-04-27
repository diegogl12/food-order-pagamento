defmodule FoodOrderPagamento.InterfaceAdapters.DTOs.PaymentStatusUpdateDTO do
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  defstruct [:payment_id, :status]

  @type t :: %__MODULE__{
          payment_id: String.t(),
          status: String.t()
        }

  def from_map(map) when is_map(map) do
    map_with_atoms =
      map
      |> Enum.map(fn {key, value} ->
        {String.to_existing_atom(key), value}
      end)

    dto = struct(__MODULE__, map_with_atoms)
    {:ok, dto}
  rescue
    ArgumentError -> {:error, "Invalid checkout data - unknown fields"}
    _ -> {:error, "Invalid checkout data"}
  end

  def to_domain(%__MODULE__{} = dto) do
    {:ok,
     %PaymentStatus{
       payment_id: dto.payment_id,
       status: dto.status
     }}
  end
end
