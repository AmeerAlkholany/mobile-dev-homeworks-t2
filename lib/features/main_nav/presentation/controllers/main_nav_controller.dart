import 'package:get/get.dart';

/// Owns the selected bottom-navigation tab. Accepts an optional `tab`
/// argument so flows can land on a specific section after navigating home.
class MainNavController extends GetxController {
  static const int tabCount = 5;

  static const int dashboardTab = 0;
  static const int unitsTab = 1;
  static const int tenantsTab = 2;
  static const int paymentsTab = 3;
  static const int profileTab = 4;

  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final Object? arguments = Get.arguments;
    if (arguments is Map && arguments['tab'] is int) {
      final int tab = arguments['tab'] as int;
      if (tab >= 0 && tab < tabCount) {
        currentIndex.value = tab;
      }
    }
  }

  void changeTab(int index) {
    if (currentIndex.value == index) {
      return;
    }
    currentIndex.value = index;
    update(<String>['main-nav']);
  }
}
