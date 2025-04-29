defmodule FoodOrderPagamento.Infra.PagamentosRepo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto"

    create table(:payments) do
      add :order_id, :uuid, null: false
      add :external_id, :string, null: false
      add :amount, :decimal, null: false
      add :payment_date, :naive_datetime, null: false
      add :payment_method, :string, null: false

      timestamps()
    end

    create unique_index(:payments, [:order_id])
  end
end
