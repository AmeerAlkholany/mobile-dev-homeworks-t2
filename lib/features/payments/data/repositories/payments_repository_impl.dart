import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payments_repository.dart';
import '../datasources/payments_local_data_source.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  PaymentsRepositoryImpl(this._localDataSource);

  final PaymentsLocalDataSource _localDataSource;

  @override
  Future<List<PaymentEntity>> getLedger({DateTime? month}) =>
      _localDataSource.fetchLedger(month: month);

  @override
  Future<PaymentEntity> recordPayment({
    required String tenantId,
    required DateTime billingMonth,
    required double amountPaid,
    required PaymentMethod method,
    String notes = '',
  }) {
    return _localDataSource.record(
      tenantId: tenantId,
      billingMonth: billingMonth,
      amountPaid: amountPaid,
      method: method,
      notes: notes,
    );
  }

  @override
  Future<PaymentEntity> markAsPaid(PaymentEntity payment) {
    return recordPayment(
      tenantId: payment.tenantId,
      billingMonth: payment.billingMonth,
      amountPaid: payment.expectedAmount,
      method: payment.method,
      notes: payment.notes,
    );
  }
}
