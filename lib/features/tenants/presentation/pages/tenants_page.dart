import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/tenant_entity.dart';
import '../controllers/tenants_controller.dart';

class TenantsPage extends GetView<TenantsController> {
  const TenantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('tenants_title'.tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'tenants-fab',
        onPressed: () => controller.openTenantForm(),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text('add_tenant'.tr),
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
                  hint: 'search_tenants_hint'.tr,
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
                        for (final TenantStatus status in TenantStatus.values)
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
                  title: status.errorMessage ?? 'error_tenants'.tr,
                  message: 'error_tenants_desc'.tr,
                  retryLabel: 'retry'.tr,
                  onRetry: controller.loadTenants,
                );
              }

              final List<TenantEntity> tenants = controller.filteredTenants;
              if (tenants.isEmpty) {
                return AppEmptyState(
                  icon: Icons.people_rounded,
                  title: 'no_tenants'.tr,
                  message: 'no_tenants_desc'.tr,
                  actionLabel: 'add_tenant'.tr,
                  onAction: () => controller.openTenantForm(),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadTenants,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                  itemCount: tenants.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final TenantEntity tenant = tenants[index];
                    return _TenantCard(
                      tenant: tenant,
                      onTap: () => controller.openTenantDetails(tenant),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TenantCard extends StatelessWidget {
  const _TenantCard({required this.tenant, required this.onTap});

  final TenantEntity tenant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final TenantStatus status = tenant.statusOn(
      DateTime.now(),
      endingSoonDays: AppConstants.leaseEndingSoonDays,
    );

    final Color background = switch (status) {
      TenantStatus.active => scheme.primaryContainer,
      TenantStatus.endingSoon => scheme.secondaryContainer,
      TenantStatus.ended => scheme.errorContainer,
    };
    final Color foreground = switch (status) {
      TenantStatus.active => scheme.onPrimaryContainer,
      TenantStatus.endingSoon => scheme.onSecondaryContainer,
      TenantStatus.ended => scheme.onErrorContainer,
    };

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 23,
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
                const SizedBox(height: 4),
                Text(
                  tenant.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${'ends_on'.tr} ${AppFormatters.fullDate(tenant.leaseEnd)}',
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
              AppPill(
                label: status.localizationKey.tr,
                background: background,
                foreground: foreground,
                compact: true,
              ),
              const SizedBox(height: 8),
              Text(
                AppFormatters.price(tenant.monthlyRent),
                style: text.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
