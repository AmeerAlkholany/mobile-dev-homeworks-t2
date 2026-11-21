import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../../tenants/domain/usecases/get_tenants_usecase.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/get_payments_usecase.dart';
import '../../domain/usecases/mark_payment_paid_usecase.dart';
import '../../domain/usecases/record_payment_usecase.dart';

class PaymentsController extends GetxController {
  PaymentsController(
    this._getPayments,
    this._recordPayment,
    this._markPaid,
    this._getTenants,
    this._refresh,
  );

  final GetPaymentsUseCase _getPayments;
  final RecordPaymentUseCase _recordPayment;
  final MarkPaymentPaidUseCase _markPaid;
  final GetTenantsUseCase _getTenants;
  final DataRefreshService _refresh;

  final Rx<DateTime> month =
      AppFormatters.monthStart(DateTime.now()).obs;
  final RxList<PaymentEntity> payments = <PaymentEntity>[].obs;
  final RxList<TenantEntity> tenants = <TenantEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  final RxString errorKey = ''.obs;

  Worker? _refreshWorker;

  @override
  void onInit() {
    super.onInit();
    _refreshWorker = _refresh.listen((int _) => load());
    load();
  }

  bool get canGoNext =>
      month.value.isBefore(AppFormatters.monthStart(DateTime.now()));

  double get expectedTotal =>
      payments.fold<double>(0, (double sum, PaymentEntity p) => sum + p.expectedAmount);

  double get collectedTotal =>
      payments.fold<double>(0, (double sum, PaymentEntity p) => sum + p.amountPaid);

  double get outstandingTotal =>
      payments.fold<double>(0, (double sum, PaymentEntity p) => sum + p.balance);

  Future<void> load() async {
    isLoading.value = true;
    errorKey.value = '';
    try {
      final List<Object> results = await Future.wait<Object>(<Future<Object>>[
        _getPayments(month: month.value),
        _getTenants(),
      ]);
      payments.assignAll(results[0] as List<PaymentEntity>);
      tenants.assignAll(results[1] as List<TenantEntity>);
    } on AppException catch (error) {
      errorKey.value = error.messageKey.tr;
    } catch (_) {
      errorKey.value = 'error_payments'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void previousMonth() {
    month.value = DateTime(month.value.year, month.value.month - 1);
    load();
  }

  void nextMonth() {
    if (!canGoNext) {
      return;
    }
    month.value = DateTime(month.value.year, month.value.month + 1);
    load();
  }

  Future<bool> recordPayment({
    required String tenantId,
    required double amount,
    required PaymentMethod method,
    String notes = '',
  }) async {
    if (isSaving.value) {
      return false;
    }
    isSaving.value = true;
    try {
      await _recordPayment(
        tenantId: tenantId,
        billingMonth: month.value,
        amountPaid: amount,
        method: method,
        notes: notes,
      );
      _refresh.notifyChanged();
      _snack('payment_recorded');
      return true;
    } on AppException catch (error) {
      _snack(error.messageKey);
      return false;
    } catch (_) {
      _snack('error_generic');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> markAsPaid(PaymentEntity payment) async {
    if (isSaving.value) {
      return;
    }
    isSaving.value = true;
    try {
      await _markPaid(payment);
      _refresh.notifyChanged();
      _snack('payment_updated');
    } on AppException catch (error) {
      _snack(error.messageKey);
    } catch (_) {
      _snack('error_generic');
    } finally {
      isSaving.value = false;
    }
  }

  void _snack(String messageKey) {
    Get.snackbar(
      'app_name'.tr,
      messageKey.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    _refreshWorker?.dispose();
    super.onClose();
  }
}
