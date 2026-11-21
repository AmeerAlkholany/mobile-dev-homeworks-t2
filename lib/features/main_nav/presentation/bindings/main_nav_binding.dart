import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../../dashboard/presentation/bindings/dashboard_binding.dart';
import '../../../payments/presentation/bindings/payments_binding.dart';
import '../../../profile/presentation/bindings/profile_binding.dart';
import '../../../tenants/presentation/bindings/tenants_binding.dart';
import '../../../units/presentation/bindings/units_binding.dart';
import '../controllers/main_nav_controller.dart';

/// The app shell composes every tab, so it registers each tab's feature graph
/// using the individual feature bindings.
class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    DashboardBinding().dependencies();
    UnitsBinding().dependencies();
    TenantsBinding().dependencies();
    PaymentsBinding().dependencies();
    ProfileBinding().dependencies();
    registerLazy<MainNavController>(() => MainNavController());
  }
}
