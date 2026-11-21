import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_pill.dart';
import '../../domain/entities/payment_entity.dart';

/// Colored pill for a rent row (paid / partial / overdue / due).
class PaymentStatusPill extends StatelessWidget {
  const PaymentStatusPill({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Color background = switch (status) {
      PaymentStatus.paid => scheme.primaryContainer,
      PaymentStatus.partial => scheme.secondaryContainer,
      PaymentStatus.overdue => scheme.errorContainer,
      PaymentStatus.due => scheme.surfaceContainerHighest,
    };
    final Color foreground = switch (status) {
      PaymentStatus.paid => scheme.onPrimaryContainer,
      PaymentStatus.partial => scheme.onSecondaryContainer,
      PaymentStatus.overdue => scheme.onErrorContainer,
      PaymentStatus.due => scheme.onSurfaceVariant,
    };

    return AppPill(
      label: status.localizationKey.tr,
      background: background,
      foreground: foreground,
      compact: true,
    );
  }
}
