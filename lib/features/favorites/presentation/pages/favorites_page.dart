import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../routes/app_routes.dart';
import '../../../properties/domain/entities/property_entity.dart';
import '../../../properties/presentation/widgets/property_card.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('favorites_title'.tr),
            Text(
              'favorites_subtitle'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        toolbarHeight: 72,
      ),
      body: controller.obx(
        (List<PropertyEntity>? properties) {
          final List<PropertyEntity> items =
              properties ?? <PropertyEntity>[];
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            itemCount: items.length,
            separatorBuilder: (_, int index) => const SizedBox(height: 14),
            itemBuilder: (BuildContext context, int index) {
              final PropertyEntity property = items[index];
              return Obx(
                () => PropertyCard(
                  property: property,
                  isFavorite: controller.favoriteIds.contains(property.id),
                  onFavoriteToggle: () =>
                      controller.toggleFavorite(property.id),
                  onTap: () => Get.toNamed(
                    AppRoutes.propertyDetails,
                    arguments: property.id,
                  ),
                ),
              );
            },
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: AppEmptyState(
          icon: Icons.favorite_border_rounded,
          title: 'no_favorites'.tr,
          message: 'no_favorites_desc'.tr,
        ),
        onError: (String? error) => AppErrorView(
          title: 'error_generic'.tr,
          retryLabel: 'retry'.tr,
          onRetry: controller.loadFavorites,
        ),
      ),
    );
  }
}
