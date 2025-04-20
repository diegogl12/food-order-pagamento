defmodule FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository do
  @behaviour FoodOrderPagamento.Domain.Repositories.PaymentRepositoryBehaviour

  alias FoodOrderPagamento.Domain.Entities.Payment

  @impl true
  def save(%Payment{} = payment) do
    # Simula salvamento bem-sucedido
    {:ok, payment}
  end

  @impl true
  def find_by_order_id(order_id) do
    # Simula busca de pagamento
    {:ok,
     %Payment{
       payment_id: "mock_payment_#{order_id}",
       order_id: order_id,
       amount: 100.0,
       status: "completed",
       created_at: DateTime.utc_now()
     }}
  end
end
