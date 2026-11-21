/// How the rent was collected.
enum PaymentMethod {
  cash('method_cash'),
  bankTransfer('method_bank');

  const PaymentMethod(this.localizationKey);

  final String localizationKey;

  static PaymentMethod fromName(String? name) {
    return PaymentMethod.values.firstWhere(
      (PaymentMethod method) => method.name == name,
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Rent state for a single billing month.
enum PaymentStatus {
  paid('status_paid'),
  partial('status_partial'),
  overdue('status_overdue'),
  due('status_due');

  const PaymentStatus(this.localizationKey);

  final String localizationKey;
}

/// One monthly rent obligation, merged with whatever was actually collected.
class PaymentEntity {
  const PaymentEntity({
    required this.id,
    required this.tenantId,
    required this.tenantName,
    required this.unitId,
    required this.unitNumber,
    required this.billingMonth,
    required this.expectedAmount,
    required this.amountPaid,
    required this.method,
    this.paidAt,
    this.notes = '',
  });

  final String id;
  final String tenantId;
  final String tenantName;
  final String unitId;
  final String unitNumber;
  final DateTime billingMonth;
  final double expectedAmount;
  final double amountPaid;
  final PaymentMethod method;
  final DateTime? paidAt;
  final String notes;

  double get balance {
    final double remaining = expectedAmount - amountPaid;
    return remaining > 0 ? remaining : 0;
  }

  bool get isSettled => amountPaid + 0.01 >= expectedAmount;

  PaymentStatus statusOn(DateTime today) {
    if (isSettled) {
      return PaymentStatus.paid;
    }
    if (amountPaid > 0) {
      return PaymentStatus.partial;
    }
    final DateTime billing =
        DateTime(billingMonth.year, billingMonth.month);
    final DateTime current = DateTime(today.year, today.month);
    return billing.isBefore(current)
        ? PaymentStatus.overdue
        : PaymentStatus.due;
  }
}
