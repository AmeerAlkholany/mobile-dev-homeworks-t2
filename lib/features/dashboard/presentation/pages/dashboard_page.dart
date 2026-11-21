import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/presentation/widgets/payment_status_pill.dart';
import '../controllers/dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('dashboard_title'.tr),
        actions: <Widget>[
          IconButton(
            onPressed: controller.load,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'retry'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.totalUnits.value == 0) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorKey.value.isNotEmpty) {
          return AppErrorView(
            title: controller.errorKey.value,
            message: 'error_dashboard_desc'.tr,
            retryLabel: 'retry'.tr,
            onRetry: controller.load,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            children: <Widget>[
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'dashboard_greeting'.tr,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.user.value?.name ?? 'app_name'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'dashboard_subtitle'.tr,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatTile(
                      icon: Icons.payments_rounded,
                      label: 'stat_collected_month'.tr,
                      value: AppFormatters.price(controller.collectedThisMonth.value),
                      footnote: 'this_month'.tr,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.schedule_rounded,
                      label: 'stat_pending_overdue'.tr,
                      value: AppFormatters.price(controller.pendingTotal.value),
                      footnote: 'this_month'.tr,
                      highlight: controller.pendingTotal.value > 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatTile(
                      icon: Icons.apartment_rounded,
                      label: 'stat_total_units'.tr,
                      value: '${controller.totalUnits.value}',
                      footnote: 'unit_count_value'
                          .trParams(<String, String>{
                        'count': '${controller.totalUnits.value}',
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.pie_chart_outline_rounded,
                      label: 'stat_occupancy'.tr,
                      value: '${controller.occupancyRate.toStringAsFixed(0)}%',
                      footnote: 'occupancy_summary'.trParams(<String, String>{
                        'occupied': '${controller.occupiedUnits.value}',
                        'vacant': '${controller.vacantUnits}',
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text('quick_actions'.tr, style: text.titleMedium),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.add_home_rounded,
                      label: 'add_unit'.tr,
                      onTap: controller.openUnitForm,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.person_add_alt_1_rounded,
                      label: 'add_tenant'.tr,
                      onTap: controller.openTenantForm,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.receipt_long_rounded,
                      label: 'record_payment'.tr,
                      onTap: controller.openPayments,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('alerts_title'.tr, style: text.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          'alerts_subtitle'.tr,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.alerts.isNotEmpty)
                    AppChoiceChip(
                      label: 'view_payments'.tr,
                      selected: false,
                      onTap: controller.openPayments,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (controller.alerts.isEmpty)
                AppEmptyState(
                  icon: Icons.task_alt_rounded,
                  title: 'alerts_empty'.tr,
                  message: 'alerts_empty_desc'.tr,
                )
              else
                for (final PaymentEntity payment in controller.alerts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      onTap: controller.openPayments,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  payment.tenantName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.titleSmall,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${AppFormatters.monthYear(payment.billingMonth)}'
                                  ' · ${'unit_label'.tr} ${payment.unitNumber}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                AppFormatters.price(payment.balance),
                                style: text.titleSmall?.copyWith(
                                  color: scheme.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              PaymentStatusPill(
                                status: payment.statusOn(DateTime.now()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.footnote,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String footnote;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final Color accent = highlight ? scheme.error : scheme.primary;

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            footnote,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Icon(icon, size: 22, color: scheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
