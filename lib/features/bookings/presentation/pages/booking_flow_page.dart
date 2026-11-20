import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../properties/domain/entities/property_entity.dart';
import '../../../properties/presentation/widgets/property_cover.dart';
import '../controllers/booking_flow_controller.dart';

class BookingFlowPage extends GetView<BookingFlowController> {
  const BookingFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final PropertyEntity? property = controller.property.value;

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: Text('booking_title'.tr)),
        body: Center(child: Text('property_not_found'.tr)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('booking_title'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppCard(
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 74,
                      width: 74,
                      child: PropertyCover(
                        property: property,
                        showDistrict: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          property.title(isArabicLocale()),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${property.district(isArabicLocale())} • ${property.cityLabelKey.tr}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionLabel(label: 'select_move_in'.tr),
            AppCard(
              onTap: () => controller.pickMoveInDate(context),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.event_rounded,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'select_move_in'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppFormatters.fullDate(
                              controller.moveInDate.value,
                            ),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionLabel(label: 'lease_duration'.tr),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final int months in controller.leaseOptions)
                    AppChoiceChip(
                      label: '$months ${'duration_months'.tr}',
                      selected: controller.leaseMonths.value == months,
                      onTap: () => controller.selectLease(months),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionLabel(label: 'tenant_notes'.tr, optional: true),
            AppTextField(
              controller: controller.notesController,
              label: 'tenant_notes'.tr,
              hint: 'notes_hint'.tr,
              maxLines: 4,
            ),
            const SizedBox(height: 22),
            _SectionLabel(label: 'price_summary'.tr),
            AppCard(
              child: Obx(
                () => Column(
                  children: <Widget>[
                    _PriceRow(
                      label: 'monthly_rent'.tr,
                      value: AppFormatters.price(property.monthlyPrice),
                    ),
                    const SizedBox(height: 8),
                    _PriceRow(
                      label: 'lease_period'.tr,
                      value:
                          '${controller.leaseMonths.value} ${'duration_months'.tr}',
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: scheme.outlineVariant.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 10),
                    _PriceRow(
                      label: 'total_price'.tr,
                      value: AppFormatters.price(controller.total),
                      highlight: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
            child: Obx(
              () => AppButton(
                label: 'confirm_booking'.tr,
                icon: Icons.check_circle_outline_rounded,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.submit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.optional = false});

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          if (optional) ...<Widget>[
            const SizedBox(width: 6),
            Text(
              '(${'optional'.tr})',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
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

    return Row(
      children: <Widget>[
        Text(
          label,
          style: text.bodyMedium?.copyWith(
            color: highlight ? scheme.onSurface : scheme.onSurfaceVariant,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: highlight
              ? text.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                )
              : text.bodyMedium,
        ),
      ],
    );
  }
}
