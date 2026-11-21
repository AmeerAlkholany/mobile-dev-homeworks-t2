import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/unit_entity.dart';
import '../controllers/unit_form_controller.dart';

class UnitFormPage extends GetView<UnitFormController> {
  const UnitFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'edit_unit'.tr : 'add_unit'.tr),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: <Widget>[
            AppTextField(
              controller: controller.unitNumberController,
              label: 'unit_number'.tr,
              hint: 'unit_number_hint'.tr,
              prefixIcon: Icons.tag_rounded,
              textInputAction: TextInputAction.next,
              validator: controller.validateUnitNumber,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: controller.floorController,
              label: 'floor'.tr,
              hint: 'floor_hint'.tr,
              prefixIcon: Icons.layers_outlined,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: controller.validateFloor,
            ),
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
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: AppTextField(
                    controller: controller.bedroomsController,
                    label: 'bedrooms'.tr,
                    hint: 'bedrooms_hint'.tr,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateBedrooms,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: controller.areaController,
                    label: 'area_sqm'.tr,
                    hint: 'area_hint'.tr,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    validator: controller.validateArea,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text('unit_type'.tr, style: text.titleSmall),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final UnitType type in UnitType.values)
                    AppChoiceChip(
                      label: type.localizationKey.tr,
                      selected: controller.type.value == type,
                      onTap: () => controller.setType(type),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text('unit_status'.tr, style: text.titleSmall),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final UnitStatus status in UnitStatus.values)
                    AppChoiceChip(
                      label: status.localizationKey.tr,
                      selected: controller.status.value == status,
                      onTap: () => controller.setStatus(status),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            AppTextField(
              controller: controller.notesController,
              label: 'unit_notes'.tr,
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
