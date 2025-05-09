ExUnit.start()
Application.ensure_all_started(:mimic)

Mox.defmock(PaymentGatewayMock, for: FoodOrderPagamento.InterfaceAdapters.Gateways.PaymentGatewayBehaviour)
Mox.defmock(OrderGatewayMock, for: FoodOrderPagamento.InterfaceAdapters.Gateways.OrderGatewayBehavior)
Mox.defmock(PaymentRepositoryMock, for: FoodOrderPagamento.Domain.Repositories.PaymentRepositoryBehaviour)
Mox.defmock(PaymentStatusRepositoryMock, for: FoodOrderPagamento.Domain.Repositories.PaymentStatusRepositoryBehaviour)

[
  FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository,
  FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentStatusRepository,
  FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController,
  FoodOrderPagamento.InterfaceAdapters.DTOs.CheckoutDTO,
  FoodOrderPagamento.InterfaceAdapters.DTOs.PaymentStatusUpdateDTO,
  FoodOrderPagamento.UseCases.RequestPayment,
  FoodOrderPagamento.UseCases.UpdatePaymentStatus,
  FoodOrderPagamento.Domain.Entities.Checkout,
  FoodOrderPagamento.InterfaceAdapters.DTOs.MercadopagoResponseDTO,
  Jason,
  Tesla,
  UUID,
  NaiveDateTime,
  Application,
  FoodOrderPagamento.Infra.PagamentosRepo,
  Ecto.Changeset,
  FoodOrderPagamento.Infra.Web.Controllers.PaymentController,
  Plug.Conn
]
|> Enum.each(&Mimic.copy/1)
