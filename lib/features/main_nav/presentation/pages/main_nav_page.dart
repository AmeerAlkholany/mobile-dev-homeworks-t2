import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../bookings/presentation/pages/my_bookings_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../properties/presentation/pages/home_page.dart';
import '../controllers/main_nav_controller.dart';

class MainNavPage extends GetView<MainNavController> {
  const MainNavPage({super.key});

  static const List<Widget> _tabs = <Widget>[
    HomePage(),
    FavoritesPage(),
    MyBookingsPage(),
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
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded),
              label: 'nav_home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border_rounded),
              selectedIcon: const Icon(Icons.favorite_rounded),
              label: 'nav_favorites'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.event_note_outlined),
              selectedIcon: const Icon(Icons.event_note_rounded),
              label: 'nav_bookings'.tr,
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
