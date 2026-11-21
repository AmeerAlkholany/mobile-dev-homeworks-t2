import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/demo_ids.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/storage_service.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../../tenants/domain/repositories/tenants_repository.dart';
import '../../../units/domain/entities/unit_entity.dart';
import '../../../units/domain/repositories/units_repository.dart';
import '../../domain/entities/payment_entity.dart';
import '../models/payment_model.dart';

abstract class PaymentsLocalDataSource {
  Future<List<PaymentModel>> fetchLedger({DateTime? month});

  Future<PaymentModel> record({
    required String tenantId,
    required DateTime billingMonth,
    required double amountPaid,
    required PaymentMethod method,
    required String notes,
  });
}

/// Builds the monthly ledger from each tenant's lease and overlays whatever
/// payments have been recorded in GetStorage.
class PaymentsStorageDataSource implements PaymentsLocalDataSource {
  const PaymentsStorageDataSource(
    this._storage,
    this._tenantsRepository,
    this._unitsRepository,
  );

  final StorageService _storage;
  final TenantsRepository _tenantsRepository;
  final UnitsRepository _unitsRepository;

  @override
  Future<List<PaymentModel>> fetchLedger({DateTime? month}) async {
    final List<Object> results = await Future.wait<Object>(
      <Future<Object>>[
        _tenantsRepository.getTenants(),
        _unitsRepository.getUnits(),
      ],
    );
    final List<TenantEntity> tenants = results[0] as List<TenantEntity>;
    final List<UnitEntity> units = results[1] as List<UnitEntity>;
    final Map<String, UnitEntity> unitsById = <String, UnitEntity>{
      for (final UnitEntity unit in units) unit.id: unit,
    };

    await _ensureSeeded(tenants);

    final List<PaymentModel> records = _readRecords();
    final List<PaymentModel> ledger = <PaymentModel>[];

    for (final TenantEntity tenant in tenants) {
      final UnitEntity? unit = unitsById[tenant.unitId];
      for (final DateTime monthStart in _leaseMonths(tenant)) {
        final PaymentModel? record = _findRecord(
          records,
          tenant.id,
          monthStart,
        );
        ledger.add(_rowFor(tenant, unit, monthStart, record));
      }
    }

    ledger.sort((PaymentModel a, PaymentModel b) {
      final int byMonth = b.billingMonth.compareTo(a.billingMonth);
      if (byMonth != 0) {
        return byMonth;
      }
      return a.tenantName.compareTo(b.tenantName);
    });

    if (month == null) {
      return ledger;
    }
    return ledger
        .where(
          (PaymentModel row) =>
              row.billingMonth.year == month.year &&
              row.billingMonth.month == month.month,
        )
        .toList();
  }

  @override
  Future<PaymentModel> record({
    required String tenantId,
    required DateTime billingMonth,
    required double amountPaid,
    required PaymentMethod method,
    required String notes,
  }) async {
    if (amountPaid <= 0) {
      throw const AppException('validation_amount');
    }

    final List<TenantEntity> tenants = await _tenantsRepository.getTenants();
    TenantEntity? tenant;
    for (final TenantEntity item in tenants) {
      if (item.id == tenantId) {
        tenant = item;
      }
    }
    if (tenant == null) {
      throw const AppException('error_tenant_required');
    }
    if (amountPaid > tenant.monthlyRent + 0.01) {
      throw const AppException('error_payment_exceeds');
    }

    await _ensureSeeded(tenants);

    final UnitEntity? unit = await _unitsRepository.getUnitById(tenant.unitId);
    final DateTime monthStart =
        DateTime(billingMonth.year, billingMonth.month);
    final List<PaymentModel> records = _readRecords();
    final PaymentModel? existing = _findRecord(records, tenantId, monthStart);

    final PaymentModel stored = PaymentModel(
      id: existing?.id ?? 'pay-${DateTime.now().microsecondsSinceEpoch}',
      tenantId: tenant.id,
      tenantName: tenant.fullName,
      unitId: tenant.unitId,
      unitNumber: unit?.unitNumber ?? existing?.unitNumber ?? '',
      billingMonth: monthStart,
      expectedAmount: tenant.monthlyRent,
      amountPaid: amountPaid,
      method: method,
      paidAt: DateTime.now(),
      notes: notes,
    );

    records.removeWhere(
      (PaymentModel item) =>
          item.tenantId == tenantId && _sameMonth(item.billingMonth, monthStart),
    );
    records.add(stored);
    await _writeRecords(records);
    return stored;
  }

  // ---------------------------------------------------------------------------
  // Seeding.
  // ---------------------------------------------------------------------------

  Future<void> _ensureSeeded(List<TenantEntity> tenants) async {
    if (_storage.readBool(AppConstants.kPaymentsSeeded)) {
      return;
    }
    final List<PaymentModel> seed = <PaymentModel>[];
    for (final TenantEntity tenant in tenants) {
      for (final DateTime monthStart in _leaseMonths(tenant)) {
        final double amount = _seededAmount(tenant, monthStart);
        if (amount <= 0) {
          continue;
        }
        seed.add(
          PaymentModel(
            id: 'seed-${tenant.id}-${monthStart.year}-${monthStart.month}',
            tenantId: tenant.id,
            tenantName: tenant.fullName,
            unitId: tenant.unitId,
            unitNumber: '',
            billingMonth: monthStart,
            expectedAmount: tenant.monthlyRent,
            amountPaid: amount,
            method: PaymentMethod.values[
                tenant.id == DemoIds.tenantCompany ? 1 : 0],
            paidAt: DateTime(monthStart.year, monthStart.month, 3),
            notes: '',
          ),
        );
      }
    }
    await _writeRecords(seed);
    await _storage.writeBool(AppConstants.kPaymentsSeeded, true);
  }

  /// Demo collection history: one tenant is overdue, one partially paid this
  /// month and one shop tenant has not paid yet, so every status is visible.
  double _seededAmount(TenantEntity tenant, DateTime month) {
    final DateTime now = DateTime.now();
    final DateTime current = DateTime(now.year, now.month);
    final DateTime previous = DateTime(now.year, now.month - 1);

    if (tenant.id == DemoIds.tenantNoura) {
      final bool skipped =
          _sameMonth(month, current) || _sameMonth(month, previous);
      return skipped ? 0 : tenant.monthlyRent;
    }
    if (tenant.id == DemoIds.tenantFahad) {
      return _sameMonth(month, current)
          ? (tenant.monthlyRent * 0.4).roundToDouble()
          : tenant.monthlyRent;
    }
    if (tenant.id == DemoIds.tenantCompany) {
      return _sameMonth(month, current) ? 0 : tenant.monthlyRent;
    }
    return tenant.monthlyRent;
  }

  // ---------------------------------------------------------------------------
  // Helpers.
  // ---------------------------------------------------------------------------

  List<DateTime> _leaseMonths(TenantEntity tenant) {
    final DateTime now = DateTime.now();
    final DateTime current = DateTime(now.year, now.month);
    final DateTime leaseStart =
        DateTime(tenant.leaseStart.year, tenant.leaseStart.month);
    final DateTime leaseEnd =
        DateTime(tenant.leaseEnd.year, tenant.leaseEnd.month);
    final DateTime lookbackStart = DateTime(
      current.year,
      current.month - (AppConstants.ledgerLookbackMonths - 1),
    );
    final DateTime first =
        leaseStart.isAfter(lookbackStart) ? leaseStart : lookbackStart;
    final DateTime last = leaseEnd.isBefore(current) ? leaseEnd : current;

    final List<DateTime> months = <DateTime>[];
    DateTime cursor = first;
    while (!cursor.isAfter(last) &&
        months.length < AppConstants.ledgerLookbackMonths) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return months;
  }

  PaymentModel _rowFor(
    TenantEntity tenant,
    UnitEntity? unit,
    DateTime monthStart,
    PaymentModel? record,
  ) {
    return PaymentModel(
      id: record?.id ?? '${tenant.id}-${monthStart.year}-${monthStart.month}',
      tenantId: tenant.id,
      tenantName: tenant.fullName,
      unitId: tenant.unitId,
      unitNumber: unit?.unitNumber ?? record?.unitNumber ?? '',
      billingMonth: monthStart,
      expectedAmount: tenant.monthlyRent,
      amountPaid: record?.amountPaid ?? 0,
      method: record?.method ?? PaymentMethod.cash,
      paidAt: record?.paidAt,
      notes: record?.notes ?? '',
    );
  }

  PaymentModel? _findRecord(
    List<PaymentModel> records,
    String tenantId,
    DateTime monthStart,
  ) {
    for (final PaymentModel record in records) {
      if (record.tenantId == tenantId &&
          _sameMonth(record.billingMonth, monthStart)) {
        return record;
      }
    }
    return null;
  }

  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  List<PaymentModel> _readRecords() {
    return _storage
        .readListOfMaps(AppConstants.kRecordedPayments)
        .map(PaymentModel.fromJson)
        .toList();
  }

  Future<void> _writeRecords(List<PaymentModel> records) {
    return _storage.writeListOfMaps(
      AppConstants.kRecordedPayments,
      records.map((PaymentModel record) => record.toJson()).toList(),
    );
  }
}
