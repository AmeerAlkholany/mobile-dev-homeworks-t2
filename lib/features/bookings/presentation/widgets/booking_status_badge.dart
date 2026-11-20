import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_pill.dart';
import '../../domain/entities/booking_entity.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final (Color background, Color foreground, IconData icon) visual =
        switch (status) {
      BookingStatus.pending => (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
          Icons.hourglass_top_rounded,
        ),
      BookingStatus.active => (
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
          Icons.check_circle_outline_rounded,
        ),
      BookingStatus.cancelled => (
          scheme.errorContainer,
          scheme.onErrorContainer,
          Icons.cancel_outlined,
        ),
    };

    return AppPill(
      label: status.labelKey.tr,
      icon: visual.$3,
      background: visual.$1,
      foreground: visual.$2,
      compact: true,
    );
  }
}
