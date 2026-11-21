import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../payments/presentation/pages/payments_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../tenants/presentation/pages/tenants_page.dart';
import '../../../units/presentation/pages/units_page.dart';
import '../controllers/main_nav_controller.dart';

class MainNavPage extends GetView<MainNavController> {
  const MainNavPage({super.key});

  static const List<Widget> _tabs = <Widget>[
    DashboardPage(),
    UnitsPage(),
    TenantsPage(),
    PaymentsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainNavController>(
        id: 'main-nav',
        builder: (MainNavController navController) => IndexedStack(
          index: navController.currentIndex.value,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: GetBuilder<MainNavController>(
        id: 'main-nav',
        builder: (MainNavController navController) => NavigationBar(
          selectedIndex: navController.currentIndex.value,
          onDestinationSelected: navController.changeTab,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard_rounded),
              label: 'nav_dashboard'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.apartment_outlined),
              selectedIcon: const Icon(Icons.apartment_rounded),
              label: 'nav_units'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline_rounded),
              selectedIcon: const Icon(Icons.people_rounded),
              label: 'nav_tenants'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.payments_outlined),
              selectedIcon: const Icon(Icons.payments_rounded),
              label: 'nav_payments'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: 'nav_profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
