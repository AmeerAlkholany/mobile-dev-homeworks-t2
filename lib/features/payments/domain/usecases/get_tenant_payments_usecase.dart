import '../entities/payment_entity.dart';
import '../repositories/payments_repository.dart';

class GetTenantPaymentsUseCase {
  const GetTenantPaymentsUseCase(this._repository);

  final PaymentsRepository _repository;

  Future<List<PaymentEntity>> call(String tenantId) async {
    final List<PaymentEntity> ledger = await _repository.getLedger();
    return ledger
        .where((PaymentEntity payment) => payment.tenantId == tenantId)
        .toList();
  }
}
