import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/domain/usecases/get_payments_usecase.dart';
import '../../../units/domain/entities/unit_entity.dart';
import '../../../units/domain/usecases/get_units_usecase.dart';

/// Aggregates units and the rent ledger into the landlord overview.
class DashboardController extends GetxController {
  DashboardController(
    this._getUnits,
    this._getPayments,
    this._getCurrentUser,
    this._refresh,
  );

  final GetUnitsUseCase _getUnits;
  final GetPaymentsUseCase _getPayments;
  final GetCurrentUserUseCase _getCurrentUser;
  final DataRefreshService _refresh;

  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final RxInt totalUnits = 0.obs;
  final RxInt occupiedUnits = 0.obs;
  final RxDouble collectedThisMonth = 0.0.obs;
  final RxDouble pendingTotal = 0.0.obs;
  final RxList<PaymentEntity> alerts = <PaymentEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorKey = ''.obs;

  Worker? _refreshWorker;

  int get vacantUnits => totalUnits.value - occupiedUnits.value;

  double get occupancyRate => totalUnits.value == 0
      ? 0
      : occupiedUnits.value / totalUnits.value * 100;

  @override
  void onInit() {
    super.onInit();
    _refreshWorker = _refresh.listen((int _) => load());
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorKey.value = '';
    try {
      final Future<UserEntity?> userFuture = _getCurrentUser();
      final List<Object> results = await Future.wait<Object>(
        <Future<Object>>[_getUnits(), _getPayments()],
      );
      final List<UnitEntity> units = results[0] as List<UnitEntity>;
      final List<PaymentEntity> ledger = results[1] as List<PaymentEntity>;
      user.value = await userFuture;

      totalUnits.value = units.length;
      occupiedUnits.value =
          units.where((UnitEntity unit) => unit.isOccupied).length;

      final DateTime now = DateTime.now();
      final DateTime current = DateTime(now.year, now.month);
      collectedThisMonth.value = ledger
          .where(
            (PaymentEntity payment) =>
                payment.billingMonth.year == current.year &&
                payment.billingMonth.month == current.month,
          )
          .fold<double>(
            0,
            (double sum, PaymentEntity payment) => sum + payment.amountPaid,
          );

      final List<PaymentEntity> outstanding = ledger
          .where(
            (PaymentEntity payment) =>
                payment.balance > 0 &&
                !payment.billingMonth.isAfter(current),
          )
          .toList();
      outstanding.sort(
        (PaymentEntity a, PaymentEntity b) =>
            a.billingMonth.compareTo(b.billingMonth),
      );
      pendingTotal.value = outstanding.fold<double>(
        0,
        (double sum, PaymentEntity payment) => sum + payment.balance,
      );
      alerts.assignAll(outstanding.take(5).toList());
    } catch (_) {
      errorKey.value = 'error_dashboard'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void openTab(int index) {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(index);
    }
  }

  void openPayments() => openTab(MainNavController.paymentsTab);

  void openUnitForm() => Get.toNamed(AppRoutes.unitForm);

  void openTenantForm() => Get.toNamed(AppRoutes.tenantForm);

  @override
  void onClose() {
    _refreshWorker?.dispose();
    super.onClose();
  }
}
