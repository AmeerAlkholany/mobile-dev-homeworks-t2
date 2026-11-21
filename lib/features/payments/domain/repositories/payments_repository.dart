import '../entities/payment_entity.dart';

/// Contract for the rent ledger and payment recording.
abstract class PaymentsRepository {
  /// Full ledger sorted newest first. When [month] is given, only that
  /// billing month is returned.
  Future<List<PaymentEntity>> getLedger({DateTime? month});

  Future<PaymentEntity> recordPayment({
    required String tenantId,
    required DateTime billingMonth,
    required double amountPaid,
    required PaymentMethod method,
    String notes,
  });

  /// Records the remaining balance as received today.
  Future<PaymentEntity> markAsPaid(PaymentEntity payment);
}
