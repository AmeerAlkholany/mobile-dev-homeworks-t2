import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../domain/entities/property_entity.dart';
import '../controllers/property_details_controller.dart';
import '../widgets/property_cover.dart';

class PropertyDetailsPage extends GetView<PropertyDetailsController> {
  const PropertyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final PropertyEntity? property = controller.property.value;
        if (property == null) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: Get.back<void>,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                Expanded(
                  child: AppErrorView(
                    title: controller.errorKey.value.tr,
                    retryLabel: 'retry'.tr,
                    onRetry: controller.reload,
                  ),
                ),
              ],
            ),
          );
        }
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 290,
              pinned: true,
              backgroundColor: scheme.surface,
              leadingWidth: 60,
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12),
                child: Center(
                  child: _CircleAction(
                    icon: Icons.arrow_back_rounded,
                    onPressed: Get.back<void>,
                  ),
                ),
              ),
              actions: <Widget>[
                Obx(
                  () => _CircleAction(
                    icon: controller.favorites.favoriteIds
                            .contains(property.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: controller.favorites.favoriteIds
                            .contains(property.id)
                        ? scheme.error
                        : scheme.onSurface,
                    onPressed: controller.toggleFavorite,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _Gallery(
                  property: property,
                  controller: controller,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _Body(property: property)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final PropertyEntity? property = controller.property.value;
        if (property == null || controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return _BookingBar(property: property, onBook: controller.startBooking);
      }),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.property, required this.controller});

  final PropertyEntity property;
  final PropertyDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PageView.builder(
          itemCount: property.galleryKeys.length,
          onPageChanged: controller.changeGalleryPage,
          itemBuilder: (BuildContext context, int index) {
            return PropertyCover(
              property: property,
              index: index,
              showDistrict: false,
            );
          },
        ),
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 30,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < property.galleryKeys.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: controller.galleryIndex.value == i ? 20 : 6,
                    decoration: BoxDecoration(
                      color: controller.galleryIndex.value == i
                          ? scheme.onPrimary
                          : scheme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  property.title(isArabicLocale()),
                  style: text.headlineSmall,
                ),
              ),
              if (property.landlordVerified)
                AppPill(
                  label: 'verified_listing'.tr,
                  icon: Icons.verified_rounded,
                  background: scheme.primaryContainer,
                  foreground: scheme.onPrimaryContainer,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(
                Icons.place_outlined,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${property.district(isArabicLocale())} • ${property.cityLabelKey.tr}',
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                AppFormatters.price(property.price),
                style: text.headlineSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  rentPeriodLabel(property.rentPeriod.isYearly),
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Spacer(),
              AppPill(
                label:
                    '★ ${property.rating.toStringAsFixed(1)} (${property.reviewsCount})',
                background: scheme.secondaryContainer,
                foreground: scheme.onSecondaryContainer,
              ),
            ],
          ),
          if (property.rentPeriod.isYearly) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              '${'monthly_equivalent'.tr}: ${AppFormatters.price(property.monthlyPrice)}',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 20),
          _SpecsRow(property: property),
          const SizedBox(height: 24),
          _SectionTitle(title: 'description'.tr),
          const SizedBox(height: 8),
          Text(
            property.description(isArabicLocale()),
            style: text.bodyMedium?.copyWith(height: 1.7),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: 'amenities'.tr),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final String amenity in property.amenities)
                AppPill(
                  label: 'amenity_$amenity'.tr,
                  icon: _amenityIcon(amenity),
                  background: scheme.surfaceContainerHighest,
                  foreground: scheme.onSurfaceVariant,
                ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: 'landlord'.tr),
          const SizedBox(height: 12),
          _LandlordCard(property: property),
          const SizedBox(height: 24),
          _SectionTitle(title: 'location'.tr),
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              children: <Widget>[
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.map_outlined, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${property.district(isArabicLocale())}, ${property.cityLabelKey.tr}',
                        style: text.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${'available_from'.tr}: ${AppFormatters.fullDate(property.availableFrom)}',
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _amenityIcon(String key) {
    return switch (key) {
      'wifi' => Icons.wifi_rounded,
      'parking' => Icons.local_parking_rounded,
      'pool' => Icons.pool_rounded,
      'gym' => Icons.fitness_center_rounded,
      'ac' => Icons.ac_unit_rounded,
      'elevator' => Icons.elevator_outlined,
      'security' => Icons.shield_outlined,
      'balcony' => Icons.balcony_outlined,
      'garden' => Icons.grass_rounded,
      'kitchen' => Icons.kitchen_outlined,
      'laundry' => Icons.local_laundry_service_outlined,
      'pets' => Icons.pets_outlined,
      _ => Icons.check_circle_outline_rounded,
    };
  }
}

class _SpecsRow extends StatelessWidget {
  const _SpecsRow({required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: <Widget>[
          if (property.bedrooms > 0)
            Expanded(
              child: _SpecItem(
                icon: Icons.bed_rounded,
                value: '${property.bedrooms}',
                label: 'bedrooms'.tr,
              ),
            ),
          Expanded(
            child: _SpecItem(
              icon: Icons.bathtub_outlined,
              value: '${property.bathrooms}',
              label: 'bathrooms'.tr,
            ),
          ),
          Expanded(
            child: _SpecItem(
              icon: Icons.square_foot_rounded,
              value: '${property.area.toInt()} ${'sqm'.tr}',
              label: 'area'.tr,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Icon(icon, color: scheme.primary),
        const SizedBox(height: 6),
        Text(value, style: text.titleSmall),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _LandlordCard extends StatelessWidget {
  const _LandlordCard({required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final String name = property.landlordName(isArabicLocale());

    return AppCard(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              name.substring(0, 1),
              style: text.titleMedium?.copyWith(
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall,
                      ),
                    ),
                    if (property.landlordVerified) ...<Widget>[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: scheme.primary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  property.landlordPhone,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => Get.snackbar(
              property.landlordName(isArabicLocale()),
              property.landlordPhone,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            ),
            icon: const Icon(Icons.call_outlined, size: 20),
            tooltip: 'contact_landlord'.tr,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, size: 21, color: color ?? scheme.onSurface),
        ),
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.property, required this.onBook});

  final PropertyEntity property;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      AppFormatters.price(property.monthlyPrice),
                      style: text.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'per_month'.tr,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 190,
                child: AppButton(
                  label: 'request_rental'.tr,
                  icon: Icons.calendar_month_rounded,
                  onPressed: onBook,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
