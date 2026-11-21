import '../../domain/entities/payment_entity.dart';

/// Serialization boundary for recorded rent payments.
class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.tenantId,
    required super.tenantName,
    required super.unitId,
    required super.unitNumber,
    required super.billingMonth,
    required super.expectedAmount,
    required super.amountPaid,
    required super.method,
    super.paidAt,
    super.notes,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: (json['id'] as String?) ?? '',
      tenantId: (json['tenant_id'] as String?) ?? '',
      tenantName: (json['tenant_name'] as String?) ?? '',
      unitId: (json['unit_id'] as String?) ?? '',
      unitNumber: (json['unit_number'] as String?) ?? '',
      billingMonth:
          DateTime.tryParse((json['billing_month'] as String?) ?? '') ??
              DateTime.now(),
      expectedAmount: (json['expected_amount'] as num?)?.toDouble() ?? 0,
      amountPaid: (json['amount_paid'] as num?)?.toDouble() ?? 0,
      method: PaymentMethod.fromName(json['method'] as String?),
      paidAt: DateTime.tryParse((json['paid_at'] as String?) ?? ''),
      notes: (json['notes'] as String?) ?? '',
    );
  }

  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      tenantId: entity.tenantId,
      tenantName: entity.tenantName,
      unitId: entity.unitId,
      unitNumber: entity.unitNumber,
      billingMonth: entity.billingMonth,
      expectedAmount: entity.expectedAmount,
      amountPaid: entity.amountPaid,
      method: entity.method,
      paidAt: entity.paidAt,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'tenant_id': tenantId,
      'tenant_name': tenantName,
      'unit_id': unitId,
      'unit_number': unitNumber,
      'billing_month': billingMonth.toIso8601String(),
      'expected_amount': expectedAmount,
      'amount_paid': amountPaid,
      'method': method.name,
      'paid_at': paidAt?.toIso8601String(),
      'notes': notes,
    };
  }
}
