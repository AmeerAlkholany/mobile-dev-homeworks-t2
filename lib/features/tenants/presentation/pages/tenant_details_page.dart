import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/presentation/widgets/payment_status_pill.dart';
import '../../domain/entities/tenant_entity.dart';
import '../controllers/tenant_details_controller.dart';

class TenantDetailsPage extends GetView<TenantDetailsController> {
  const TenantDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('tenant_details'.tr),
        actions: <Widget>[
          // `tenant` is a plain field, so the bundle is the only observable
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
                  icon: const Icon(Icons.person_remove_outlined),
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
            title: status.errorMessage ?? 'error_tenants'.tr,
            message: 'error_tenants_desc'.tr,
            retryLabel: 'retry'.tr,
            onRetry: controller.load,
          );
        }

        final TenantDetailsBundle? bundle = controller.bundle.value;
        if (bundle == null) {
          return AppEmptyState(
            icon: Icons.person_search_rounded,
            title: 'no_tenants'.tr,
            message: 'no_tenants_desc'.tr,
          );
        }

        final DateTime today = DateTime.now();
        final TenantStatus tenantStatus = bundle.tenant.statusOn(
          today,
          endingSoonDays: AppConstants.leaseEndingSoonDays,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
          children: <Widget>[
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: scheme.primaryContainer,
                    child: Text(
                      bundle.tenant.initials,
                      style: text.titleLarge?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          bundle.tenant.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          bundle.tenant.phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppPill(
                          label: tenantStatus.localizationKey.tr,
                          compact: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('lease_info'.tr, style: text.titleMedium),
            const SizedBox(height: 10),
            AppCard(
              child: Column(
                children: <Widget>[
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'national_id'.tr,
                    value: bundle.tenant.nationalId,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.home_work_outlined,
                    label: 'assigned_unit'.tr,
                    value: bundle.unit == null
                        ? '—'
                        : '${'unit'.tr} ${bundle.unit!.unitNumber}',
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    label: 'monthly_rent'.tr,
                    value: AppFormatters.price(bundle.tenant.monthlyRent),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.event_outlined,
                    label: 'lease_start'.tr,
                    value: AppFormatters.fullDate(bundle.tenant.leaseStart),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.event_available_outlined,
                    label: 'lease_end'.tr,
                    value: AppFormatters.fullDate(bundle.tenant.leaseEnd),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'remaining_balance'.tr,
                    value: AppFormatters.price(bundle.remainingBalance),
                  ),
                  if (bundle.tenant.notes.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.sticky_note_2_outlined,
                      label: 'notes'.tr,
                      value: bundle.tenant.notes,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('payment_history'.tr, style: text.titleMedium),
            const SizedBox(height: 10),
            if (bundle.payments.isEmpty)
              AppCard(
                child: Text(
                  'no_payments'.tr,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final PaymentEntity payment in bundle.payments.take(6))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppFormatters.monthYear(payment.billingMonth),
                                style: text.titleSmall,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${'amount_paid'.tr}: '
                                '${AppFormatters.price(payment.amountPaid)}',
                                style: text.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PaymentStatusPill(status: payment.statusOn(today)),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 12),
            AppButton(
              label: 'edit_tenant'.tr,
              icon: Icons.edit_outlined,
              variant: AppButtonVariant.outlined,
              onPressed: controller.edit,
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
        title: Text('delete_tenant_question'.tr),
        content: Text('delete_tenant_desc'.tr),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
