import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../domain/entities/property_entity.dart';
import 'property_cover.dart';

/// Listing card reused by the home feed and the favorites tab.
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
  });

  final PropertyEntity property;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: SizedBox(
              height: 172,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  PropertyCover(property: property),
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: _FavoriteButton(
                      isFavorite: isFavorite,
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                  if (property.featured)
                    PositionedDirectional(
                      top: 12,
                      start: 12,
                      child: AppPill(
                        label: 'featured'.tr,
                        icon: Icons.star_rounded,
                        background: scheme.secondaryContainer,
                        foreground: scheme.onSecondaryContainer,
                      ),
                    ),
                  PositionedDirectional(
                    bottom: 12,
                    end: 12,
                    child: AppPill(
                      label: '★ ${property.rating.toStringAsFixed(1)}',
                      background: scheme.surface.withValues(alpha: 0.94),
                      foreground: scheme.onSurface,
                      compact: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  property.title(isArabicLocale()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.place_outlined,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${property.district(isArabicLocale())} • ${property.cityLabelKey.tr}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Text(
                      AppFormatters.price(property.price),
                      style: text.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rentPeriodLabel(property.rentPeriod.isYearly),
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    _Spec(
                      icon: Icons.bed_rounded,
                      value: '${property.bedrooms}',
                      show: property.bedrooms > 0,
                    ),
                    _Spec(
                      icon: Icons.bathtub_outlined,
                      value: '${property.bathrooms}',
                    ),
                    _Spec(
                      icon: Icons.square_foot_rounded,
                      value: '${property.area.toInt()}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

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
          padding: const EdgeInsets.all(8),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 20,
            color: isFavorite ? scheme.error : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.value, this.show = true});

  final IconData icon;
  final String value;
  final bool show;

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: scheme.onSurfaceVariant),
          const SizedBox(width: 3),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
