import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/booking_entity.dart';
import '../controllers/my_bookings_controller.dart';
import '../widgets/booking_card.dart';

class MyBookingsPage extends GetView<MyBookingsController> {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('bookings_title'.tr),
            Text(
              'bookings_subtitle'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        toolbarHeight: 72,
      ),
      body: GetBuilder<MyBookingsController>(
        builder: (MyBookingsController bookingsController) {
          return bookingsController.obx(
            (List<BookingEntity>? bookings) {
              final List<BookingEntity> items =
                  bookings ?? <BookingEntity>[];
              return RefreshIndicator(
                onRefresh: bookingsController.loadBookings,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, int index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (BuildContext context, int index) {
                    final BookingEntity booking = items[index];
                    return BookingCard(
                      booking: booking,
                      onCancel: () => _confirmCancel(context, booking),
                    );
                  },
                ),
              );
            },
            onLoading: const Center(child: CircularProgressIndicator()),
            onEmpty: AppEmptyState(
              icon: Icons.event_note_rounded,
              title: 'no_bookings'.tr,
              message: 'no_bookings_desc'.tr,
            ),
            onError: (String? error) => AppErrorView(
              title: 'error_bookings'.tr,
              retryLabel: 'retry'.tr,
              onRetry: bookingsController.loadBookings,
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    BookingEntity booking,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('cancel_booking_question'.tr),
        content: Text('cancel_booking_desc'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('keep_booking'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('cancel_booking'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.cancelBooking(booking.id);
    }
  }
}
