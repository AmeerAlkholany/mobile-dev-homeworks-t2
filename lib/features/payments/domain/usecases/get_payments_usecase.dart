import '../entities/payment_entity.dart';
import '../repositories/payments_repository.dart';

class GetPaymentsUseCase {
  const GetPaymentsUseCase(this._repository);

  final PaymentsRepository _repository;

  Future<List<PaymentEntity>> call({DateTime? month}) =>
      _repository.getLedger(month: month);
}
