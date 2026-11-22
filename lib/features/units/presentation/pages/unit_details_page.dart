import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../controllers/unit_details_controller.dart';
import '../widgets/unit_status_badge.dart';
import '../widgets/unit_type_avatar.dart';

class UnitDetailsPage extends GetView<UnitDetailsController> {
  const UnitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('unit_details'.tr),
        actions: <Widget>[
          // `unit` is a plain field, so the bundle is the only observable
          // these buttons can key off; one `Obx` covers both of them.
          Obx(() {
            final bool ready = controller.bundle.value != null;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: ready ? controller.edit : null,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'edit'.tr,
                ),
                IconButton(
                  onPressed: ready ? () => _confirmDelete(context) : null,
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: 'delete'.tr,
                ),
              ],
            );
          }),
        ],
      ),
      // `StateMixin` notifies `GetBuilder`/`SimpleBuilder` listeners, not
      // `Obx` proxies, so the loading branch must use `SimpleBuilder`.
      body: SimpleBuilder(builder: (_) {
        final RxStatus status = controller.status;
        if (status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status.isError) {
          return AppErrorView(
            title: status.errorMessage ?? 'error_units'.tr,
            message: 'error_units_desc'.tr,
            retryLabel: 'retry'.tr,
            onRetry: controller.load,
          );
        }

        final UnitDetailsBundle? bundle = controller.bundle.value;
        if (bundle == null) {
          return AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'unit_not_found'.tr,
            message: 'unit_not_found_desc'.tr,
          );
        }

        final UnitEntity unit = bundle.unit;
        final TenantEntity? tenant = bundle.tenant;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
          children: <Widget>[
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: <Widget>[
                  UnitTypeAvatar(type: unit.type, size: 56),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${'unit'.tr} ${unit.unitNumber}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          unit.type.localizationKey.tr,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            UnitStatusBadge(status: unit.status),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                AppFormatters.price(unit.monthlyRent),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.titleSmall?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('unit_specs'.tr, style: text.titleMedium),
            const SizedBox(height: 10),
            AppCard(
              child: Column(
                children: <Widget>[
                  _SpecRow(
                    icon: Icons.layers_outlined,
                    label: 'floor'.tr,
                    value: '${unit.floor}',
                  ),
                  const SizedBox(height: 12),
                  _SpecRow(
                    icon: Icons.bed_outlined,
                    label: 'bedrooms'.tr,
                    value: '${unit.bedrooms}',
                  ),
                  const SizedBox(height: 12),
                  _SpecRow(
                    icon: Icons.square_foot_rounded,
                    label: 'area_sqm'.tr,
                    value: '${AppFormatters.amount(unit.areaSqm)} ${'sqm'.tr}',
                  ),
                  const SizedBox(height: 12),
                  _SpecRow(
                    icon: Icons.payments_outlined,
                    label: 'monthly_rent'.tr,
                    value: AppFormatters.price(unit.monthlyRent),
                  ),
                  if (unit.notes.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    _SpecRow(
                      icon: Icons.sticky_note_2_outlined,
                      label: 'unit_notes'.tr,
                      value: unit.notes,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('assigned_tenant'.tr, style: text.titleMedium),
            const SizedBox(height: 10),
            if (tenant != null)
              AppCard(
                onTap: () => controller.openTenant(tenant),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: scheme.primaryContainer,
                      child: Text(
                        tenant.initials,
                        style: text.titleSmall?.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tenant.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleSmall,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tenant.phone,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppPill(
                      label: 'view_tenant'.tr,
                      icon: Icons.chevron_right_rounded,
                      background: scheme.surfaceContainerHighest,
                      foreground: scheme.onSurfaceVariant,
                      compact: true,
                    ),
                  ],
                ),
              )
            else
              AppCard(
                child: Row(
                  children: <Widget>[
                    Icon(
                      unit.isVacant
                          ? Icons.meeting_room_outlined
                          : Icons.build_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        unit.isVacant
                            ? 'unit_is_vacant'.tr
                            : 'unit_under_maintenance'.tr,
                        style: text.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 22),
            AppButton(
              label: 'view_payment_history'.tr,
              icon: Icons.receipt_long_outlined,
              variant: AppButtonVariant.outlined,
              onPressed: controller.openPaymentHistory,
            ),
          ],
        );
      }),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('delete_unit_question'.tr),
        content: Text('delete_unit_desc'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.delete();
    }
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: text.bodyMedium,
          ),
        ),
      ],
    );
  }
}
