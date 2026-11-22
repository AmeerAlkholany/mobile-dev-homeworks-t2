import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/unit_entity.dart';
import '../controllers/units_controller.dart';
import '../widgets/unit_card.dart';

class UnitsPage extends GetView<UnitsController> {
  const UnitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('units_title'.tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'units-fab',
        onPressed: () => controller.openUnitForm(),
        icon: const Icon(Icons.add_rounded),
        label: Text('add_unit'.tr),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppTextField(
                  controller: controller.searchController,
                  label: 'search'.tr,
                  hint: 'search_units_hint'.tr,
                  prefixIcon: Icons.search_rounded,
                  textInputAction: TextInputAction.search,
                  onChanged: controller.onSearchChanged,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        AppChoiceChip(
                          label: 'all'.tr,
                          selected: controller.statusFilter.value == null,
                          onTap: () => controller.setStatusFilter(null),
                        ),
                        for (final UnitStatus status in UnitStatus.values)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: AppChoiceChip(
                              label: status.localizationKey.tr,
                              selected:
                                  controller.statusFilter.value == status,
                              onTap: () => controller.setStatusFilter(status),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // `StateMixin` notifies `GetBuilder`/`SimpleBuilder` listeners, not
            // `Obx` proxies, so the loading branch must use `SimpleBuilder`.
            child: SimpleBuilder(builder: (_) {
              final RxStatus status = controller.status;
              if (status.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (status.isError) {
                return AppErrorView(
                  title: status.errorMessage ?? 'error_units'.tr,
                  message: 'error_units_desc'.tr,
                  retryLabel: 'retry'.tr,
                  onRetry: controller.loadUnits,
                );
              }

              // The search query and status filter are observables, so the
              // list itself still needs `Obx` to rebuild on those changes.
              return Obx(() {
                final List<UnitEntity> units = controller.filteredUnits;
                if (units.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.apartment_rounded,
                    title: 'no_units'.tr,
                    message: 'no_units_desc'.tr,
                    actionLabel: 'add_unit'.tr,
                    onAction: () => controller.openUnitForm(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadUnits,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                    itemCount: units.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final UnitEntity unit = units[index];
                      return UnitCard(
                        unit: unit,
                        onTap: () => controller.openUnitDetails(unit),
                      );
                    },
                  ),
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}
