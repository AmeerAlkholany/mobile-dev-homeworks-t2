import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../../bookings/presentation/bindings/my_bookings_binding.dart';
import '../../../favorites/presentation/bindings/favorites_binding.dart';
import '../../../profile/presentation/bindings/profile_binding.dart';
import '../../../properties/presentation/bindings/home_binding.dart';
import '../controllers/main_nav_controller.dart';

/// The app shell composes every tab, so it registers each tab's feature graph
/// using the individual feature bindings.
class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    FavoritesBinding().dependencies();
    MyBookingsBinding().dependencies();
    ProfileBinding().dependencies();
    registerLazy<MainNavController>(() => MainNavController());
  }
}
