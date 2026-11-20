import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../domain/entities/booking_entity.dart';
import 'booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onCancel,
  });

  final BookingEntity booking;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  booking.title(isArabicLocale()),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall,
                ),
              ),
              const SizedBox(width: 8),
              BookingStatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 8),
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
                  booking.cityLabelKey.tr,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '${'requested_on'.tr}: ${AppFormatters.fullDate(booking.createdAt)}',
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _Info(
                  label: 'move_in'.tr,
                  value: AppFormatters.fullDate(booking.moveInDate),
                ),
              ),
              Expanded(
                child: _Info(
                  label: 'lease_period'.tr,
                  value:
                      '${booking.leaseMonths} ${'duration_months'.tr}',
                ),
              ),
              Expanded(
                child: _Info(
                  label: 'total_price'.tr,
                  value: AppFormatters.price(booking.totalPrice),
                  highlight: true,
                ),
              ),
            ],
          ),
          if (booking.notes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                booking.notes,
                style: text.bodySmall?.copyWith(height: 1.4),
              ),
            ),
          ],
          if (booking.isCancellable) ...<Widget>[
            const SizedBox(height: 6),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text('cancel_booking'.tr),
                style: TextButton.styleFrom(foregroundColor: scheme.error),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: text.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: highlight ? scheme.primary : scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
