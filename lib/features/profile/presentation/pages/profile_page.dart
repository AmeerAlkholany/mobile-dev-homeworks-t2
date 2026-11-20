import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_pill.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('profile_title'.tr),
      ),
      body: Obx(() {
        final UserEntity? user = controller.user.value;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          children: <Widget>[
            if (controller.isLoading.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...<Widget>[
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: scheme.primaryContainer,
                      child: Text(
                        user?.initials ?? 'E',
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
                            user?.name ?? 'app_name'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user?.email ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AppPill(
                            label: 'verified_listing'.tr,
                            icon: Icons.verified_rounded,
                            background: scheme.primaryContainer,
                            foreground: scheme.onPrimaryContainer,
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text('account_settings'.tr, style: text.titleMedium),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _SettingIcon(icon: Icons.translate_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'language'.tr,
                            style: text.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Row(
                        children: <Widget>[
                          AppChoiceChip(
                            label: 'arabic'.tr,
                            selected: controller.locale.isArabic,
                            onTap: () => controller
                                .setLocale(LocaleService.arabic),
                          ),
                          const SizedBox(width: 8),
                          AppChoiceChip(
                            label: 'english'.tr,
                            selected: !controller.locale.isArabic,
                            onTap: () => controller
                                .setLocale(LocaleService.english),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: scheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    Obx(
                      () => SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        secondary: _SettingIcon(
                          icon: controller.theme.isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                        ),
                        title: Text(
                          controller.theme.isDark
                              ? 'dark_mode'.tr
                              : 'light_mode'.tr,
                          style: text.titleSmall,
                        ),
                        subtitle: Text(
                          'appearance'.tr,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        value: controller.theme.isDark,
                        onChanged: (_) => controller.toggleTheme(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (user != null) ...<Widget>[
                Text('about_app'.tr, style: text.titleMedium),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    children: <Widget>[
                      _InfoRow(
                        icon: Icons.mail_outline_rounded,
                        label: 'email_label'.tr,
                        value: user.email,
                      ),
                      const SizedBox(height: 14),
                      _InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'phone_label'.tr,
                        value: user.phone,
                      ),
                      const SizedBox(height: 14),
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'member_since'.tr,
                        value: AppFormatters.monthYear(user.joinedAt),
                      ),
                      const SizedBox(height: 14),
                      Divider(
                        color: scheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'about_app_desc'.tr,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
              Obx(
                () => AppButton(
                  label: 'logout'.tr,
                  icon: Icons.logout_rounded,
                  variant: AppButtonVariant.outlined,
                  isLoading: controller.isLoggingOut.value,
                  onPressed: () => _confirmLogout(context),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${'app_version'.tr} ${AppConstants.appVersion}',
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('logout_question'.tr),
        content: Text('logout_desc'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.logout();
    }
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: scheme.onSurfaceVariant),
    );
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
      children: <Widget>[
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Text(
          label,
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: text.bodyMedium,
          ),
        ),
      ],
    );
  }
}
