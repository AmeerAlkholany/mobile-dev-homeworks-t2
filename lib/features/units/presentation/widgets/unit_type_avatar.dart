import 'package:flutter/material.dart';

import '../../domain/entities/unit_entity.dart';

/// Tinted square icon that represents the unit type.
class UnitTypeAvatar extends StatelessWidget {
  const UnitTypeAvatar({super.key, required this.type, this.size = 48});

  final UnitType type;
  final double size;

  static IconData iconFor(UnitType type) {
    switch (type) {
      case UnitType.apartment:
        return Icons.apartment_rounded;
      case UnitType.shop:
        return Icons.storefront_rounded;
      case UnitType.office:
        return Icons.business_center_rounded;
      case UnitType.studio:
        return Icons.chair_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        iconFor(type),
        size: size * 0.48,
        color: scheme.onPrimaryContainer,
      ),
    );
  }
}
