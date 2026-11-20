import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../domain/entities/property_entity.dart';

IconData propertyCategoryIcon(PropertyCategory category) {
  return switch (category) {
    PropertyCategory.apartment => Icons.apartment_rounded,
    PropertyCategory.villa => Icons.villa_rounded,
    PropertyCategory.office => Icons.business_center_rounded,
    PropertyCategory.studio => Icons.weekend_rounded,
  };
}

/// Decorative gradient "photo" for a listing. Ejary runs fully offline, so the
/// header art is generated from the theme instead of remote images.
class PropertyCover extends StatelessWidget {
  const PropertyCover({
    super.key,
    required this.property,
    this.index = 0,
    this.showDistrict = true,
  });

  final PropertyEntity property;
  final int index;
  final bool showDistrict;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<Color> gradient = propertyGradient(
      scheme,
      property.id.hashCode + index,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PositionedDirectional(
            top: -30,
            end: -20,
            child: _Bubble(size: 130, color: scheme.surface.withValues(alpha: 0.22)),
          ),
          PositionedDirectional(
            bottom: -40,
            start: -30,
            child: _Bubble(size: 160, color: scheme.primary.withValues(alpha: 0.10)),
          ),
          Center(
            child: Icon(
              propertyCategoryIcon(property.category),
              size: 66,
              color: scheme.primary.withValues(alpha: 0.55),
            ),
          ),
          if (showDistrict)
            PositionedDirectional(
              start: 14,
              bottom: 12,
              end: 14,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppPill(
                  label:
                      '${property.district(isArabicLocale())} • ${property.cityLabelKey.tr}',
                  icon: Icons.place_outlined,
                  background: scheme.surface.withValues(alpha: 0.92),
                  foreground: scheme.onSurface,
                  compact: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
