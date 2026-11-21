import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../units/domain/entities/unit_entity.dart';
import '../controllers/tenant_form_controller.dart';

class TenantFormPage extends GetView<TenantFormController> {
  const TenantFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'edit_tenant'.tr : 'add_tenant'.tr),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: <Widget>[
            AppTextField(
              controller: controller.fullNameController,
              label: 'full_name'.tr,
              hint: 'name_hint'.tr,
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: controller.validateFullName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: controller.phoneController,
              label: 'phone'.tr,
              hint: 'phone_hint'.tr,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: controller.validatePhone,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: controller.nationalIdController,
              label: 'national_id'.tr,
              hint: 'national_id_hint'.tr,
              prefixIcon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: controller.validateNationalId,
            ),
            const SizedBox(height: 22),
            Text('assigned_unit'.tr, style: text.titleSmall),
            const SizedBox(height: 10),
            Obx(() {
              final List<UnitEntity> units = controller.availableUnits;
              if (units.isEmpty) {
                return Text(
                  'no_vacant_units'.tr,
                  style: text.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final UnitEntity unit in units)
                    AppChoiceChip(
                      label: '${'unit'.tr} ${unit.unitNumber}',
                      selected: controller.selectedUnitId.value == unit.id,
                      onTap: () => controller.selectUnit(unit),
                    ),
                ],
              );
            }),
            const SizedBox(height: 16),
            AppTextField(
              controller: controller.rentController,
              label: 'monthly_rent'.tr,
              hint: 'rent_hint'.tr,
              prefixIcon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: controller.validateRent,
            ),
            const SizedBox(height: 22),
            Text('lease_period'.tr, style: text.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Obx(
                    () => _DateField(
                      label: 'lease_start'.tr,
                      value: controller.leaseStart.value,
                      onTap: () => controller.pickLeaseDate(
                        context,
                        start: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => _DateField(
                      label: 'lease_end'.tr,
                      value: controller.leaseEnd.value,
                      onTap: () => controller.pickLeaseDate(
                        context,
                        start: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            AppTextField(
              controller: controller.notesController,
              label: 'notes'.tr,
              hint: 'notes_hint'.tr,
              maxLines: 3,
            ),
            const SizedBox(height: 26),
            Obx(
              () => AppButton(
                label: 'save'.tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              AppFormatters.fullDate(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}
