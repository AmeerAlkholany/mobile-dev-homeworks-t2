import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_pill.dart';
import '../../domain/entities/unit_entity.dart';

/// Status pill for a unit (occupied / vacant / maintenance).
class UnitStatusBadge extends StatelessWidget {
  const UnitStatusBadge({super.key, required this.status});

  final UnitStatus status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    late final Color background;
    late final Color foreground;

    switch (status) {
      case UnitStatus.occupied:
        background = scheme.primaryContainer;
        foreground = scheme.onPrimaryContainer;
      case UnitStatus.vacant:
        background = scheme.secondaryContainer;
        foreground = scheme.onSecondaryContainer;
      case UnitStatus.maintenance:
        background = scheme.errorContainer;
        foreground = scheme.onErrorContainer;
    }

    return AppPill(
      label: status.localizationKey.tr,
      background: background,
      foreground: foreground,
      compact: true,
    );
  }
}
