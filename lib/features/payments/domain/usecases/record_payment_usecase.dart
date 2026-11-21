import '../entities/payment_entity.dart';
import '../repositories/payments_repository.dart';

class RecordPaymentUseCase {
  const RecordPaymentUseCase(this._repository);

  final PaymentsRepository _repository;

  Future<PaymentEntity> call({
    required String tenantId,
    required DateTime billingMonth,
    required double amountPaid,
    required PaymentMethod method,
    String notes = '',
  }) {
    return _repository.recordPayment(
      tenantId: tenantId,
      billingMonth: billingMonth,
      amountPaid: amountPaid,
      method: method,
      notes: notes,
    );
  }
}
