import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../getx/bindings/counter_binding.dart';
import '../getx/views/counter_page.dart';
import '../riverpod/views/counter_page.dart';
import '../shared/theme/app_theme.dart';

/// Landing screen and the only widget that knows both implementations exist.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter State Management')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Interactive Counter',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The same counter, timer and lifecycle behaviour implemented twice with '
                    'different state management solutions.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ImplementationCard(
                    title: 'GetX Counter',
                    subtitle: 'GetxController · Obx · Bindings',
                    description:
                        'Reactive Rx variables driven by a GetxController and injected with a GetX binding.',
                    icon: Icons.bolt_rounded,
                    accentColor: AppTheme.getxAccent,
                    onTap: () => Get.to<void>(
                      () => const GetxCounterPage(),
                      binding: CounterBinding(),
                      transition: Transition.cupertino,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ImplementationCard(
                    title: 'Riverpod Counter',
                    subtitle: 'NotifierProvider.autoDispose · ref.watch',
                    description:
                        'Immutable state managed by a Riverpod Notifier and consumed by ConsumerWidgets.',
                    icon: Icons.auto_awesome_rounded,
                    accentColor: AppTheme.riverpodAccent,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const RiverpodCounterPage()),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Both screens implement identical rules; only the state layer differs.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImplementationCard extends StatelessWidget {
  const _ImplementationCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accentColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
