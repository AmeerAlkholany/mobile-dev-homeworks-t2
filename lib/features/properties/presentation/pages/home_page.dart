import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/property_entity.dart';
import '../controllers/home_controller.dart';
import '../widgets/property_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final AuthService auth = Get.find<AuthService>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'home_greeting'.tr,
                          style: text.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.displayName.isEmpty
                              ? 'home_title'.tr
                              : auth.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: scheme.primaryContainer,
                    child: Text(
                      _initials(auth.displayName),
                      style: text.titleMedium?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'search_hint'.tr,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: Obx(
                    () => controller.searchQuery.value.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: controller.clearSearch,
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'clear'.tr,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 40,
              child: Obx(
                () => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: <Widget>[
                    AppChoiceChip(
                      label: 'category_all'.tr,
                      selected: controller.selectedCategory.value == null,
                      onTap: () => controller.selectCategory(null),
                    ),
                    for (final PropertyCategory category
                        in PropertyCategory.values) ...<Widget>[
                      const SizedBox(width: 8),
                      AppChoiceChip(
                        label: category.labelKey.tr,
                        selected:
                            controller.selectedCategory.value == category,
                        onTap: () => controller.selectCategory(category),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: <Widget>[
                  Obx(
                    () => TextButton.icon(
                      onPressed: () => controller.openFilters(context),
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: Text(controller.activeCityLabel),
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => controller.hasActiveFilters
                        ? TextButton(
                            onPressed: controller.resetFilters,
                            child: Text('reset_filters'.tr),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.obx(
                (List<PropertyEntity>? properties) {
                  final List<PropertyEntity> items =
                      properties ?? <PropertyEntity>[];
                  return RefreshIndicator(
                    onRefresh: controller.loadProperties,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: items.length + 1,
                      separatorBuilder: (_, int index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Text(
                            '${items.length} ${'properties_found'.tr}',
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          );
                        }
                        final PropertyEntity property = items[index - 1];
                        return Obx(
                          () => PropertyCard(
                            property: property,
                            isFavorite: controller.favorites.favoriteIds
                                .contains(property.id),
                            onFavoriteToggle: () =>
                                controller.toggleFavorite(property.id),
                            onTap: () => controller.openDetails(property.id),
                          ),
                        );
                      },
                    ),
                  );
                },
                onLoading: const Center(child: CircularProgressIndicator()),
                onEmpty: AppEmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'no_properties'.tr,
                  message: 'no_properties_desc'.tr,
                  actionLabel:
                      controller.hasActiveFilters ? 'reset_filters'.tr : null,
                  onAction: controller.hasActiveFilters
                      ? controller.resetFilters
                      : null,
                ),
                onError: (String? error) => AppErrorView(
                  title: 'error_properties'.tr,
                  message: 'error_properties_desc'.tr,
                  retryLabel: 'retry'.tr,
                  onRetry: controller.loadProperties,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'E';
    }
    final List<String> parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
