import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../controllers/payments_controller.dart';
import '../widgets/payment_status_pill.dart';

class PaymentsPage extends GetView<PaymentsController> {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('payments_title'.tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'payments-fab',
        onPressed: () => _openRecordSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: Text('record_payment_button'.tr),
      ),
      body: Obx(() {
        if (controller.errorKey.value.isNotEmpty) {
          return AppErrorView(
            title: controller.errorKey.value,
            message: 'error_payments_desc'.tr,
            retryLabel: 'retry'.tr,
            onRetry: controller.load,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            children: <Widget>[
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: controller.previousMonth,
                          icon: const Icon(Icons.chevron_left_rounded),
                          tooltip: 'previous_month'.tr,
                        ),
                        Expanded(
                          child: Text(
                            AppFormatters.monthLabel(controller.month.value),
                            textAlign: TextAlign.center,
                            style: text.titleMedium,
                          ),
                        ),
                        IconButton(
                          onPressed:
                              controller.canGoNext ? controller.nextMonth : null,
                          icon: const Icon(Icons.chevron_right_rounded),
                          tooltip: 'next_month'.tr,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _SummaryTile(
                            label: 'amount_paid'.tr,
                            value: AppFormatters.price(
                              controller.collectedTotal,
                            ),
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryTile(
                            label: 'remaining_amount'.tr,
                            value: AppFormatters.price(
                              controller.outstandingTotal,
                            ),
                            color: controller.outstandingTotal > 0
                                ? scheme.error
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.payments.isEmpty)
                AppEmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: 'no_payments'.tr,
                  message: 'no_payments_desc'.tr,
                )
              else ...<Widget>[
                Text('payments_subtitle'.tr, style: text.titleSmall),
                const SizedBox(height: 10),
                for (final PaymentEntity payment in controller.payments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PaymentRow(
                      payment: payment,
                      onMarkPaid: () => _confirmMarkPaid(context, payment),
                    ),
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Future<void> _openRecordSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) =>
          _RecordPaymentSheet(controller: controller),
    );
  }

  Future<void> _confirmMarkPaid(
    BuildContext context,
    PaymentEntity payment,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('mark_paid_question'.tr),
        content: Text('mark_paid_desc'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.markAsPaid(payment);
    }
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment, required this.onMarkPaid});

  final PaymentEntity payment;
  final VoidCallback onMarkPaid;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final PaymentStatus status = payment.statusOn(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
                      '${'unit_label'.tr} ${payment.unitNumber}',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PaymentStatusPill(status: status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${'amount_paid'.tr}: '
                  '${AppFormatters.price(payment.amountPaid)} / '
                  '${AppFormatters.price(payment.expectedAmount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (payment.balance > 0)
                TextButton(
                  onPressed: onMarkPaid,
                  child: Text('mark_as_paid'.tr),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordPaymentSheet extends StatefulWidget {
  const _RecordPaymentSheet({required this.controller});

  final PaymentsController controller;

  @override
  State<_RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends State<_RecordPaymentSheet> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String? _tenantId;
  PaymentMethod _method = PaymentMethod.cash;

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final double? amount =
        double.tryParse(_amount.text.trim().replaceAll(',', ''));
    if (_tenantId == null) {
      _snack('select_tenant'.tr);
      return;
    }
    if (amount == null || amount <= 0) {
      _snack('validation_amount'.tr);
      return;
    }
    final bool saved = await widget.controller.recordPayment(
      tenantId: _tenantId!,
      amount: amount,
      method: _method,
      notes: _notes.text.trim(),
    );
    if (saved && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _snack(String message) {
    Get.snackbar(
      'app_name'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final List<TenantEntity> tenants = widget.controller.tenants;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('record_payment_button'.tr, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(
              AppFormatters.monthLabel(widget.controller.month.value),
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            Text('select_tenant'.tr, style: text.titleSmall),
            const SizedBox(height: 10),
            if (tenants.isEmpty)
              Text(
                'no_tenants'.tr,
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final TenantEntity tenant in tenants)
                    AppChoiceChip(
                      label: tenant.fullName,
                      selected: _tenantId == tenant.id,
                      onTap: () => setState(() => _tenantId = tenant.id),
                    ),
                ],
              ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _amount,
              label: 'amount_paid'.tr,
              hint: 'amount_hint'.tr,
              prefixIcon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Text('payment_method'.tr, style: text.titleSmall),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: <Widget>[
                for (final PaymentMethod method in PaymentMethod.values)
                  AppChoiceChip(
                    label: method.localizationKey.tr,
                    selected: _method == method,
                    onTap: () => setState(() => _method = method),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _notes,
              label: 'notes'.tr,
              hint: 'notes_hint'.tr,
              maxLines: 2,
            ),
            const SizedBox(height: 22),
            Obx(
              () => AppButton(
                label: 'save'.tr,
                isLoading: widget.controller.isSaving.value,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
