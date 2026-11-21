import '../entities/payment_entity.dart';
import '../repositories/payments_repository.dart';

class MarkPaymentPaidUseCase {
  const MarkPaymentPaidUseCase(this._repository);

  final PaymentsRepository _repository;

  Future<PaymentEntity> call(PaymentEntity payment) =>
      _repository.markAsPaid(payment);
}
