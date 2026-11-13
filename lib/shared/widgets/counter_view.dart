import 'package:flutter/material.dart';

import '../models/timer_status.dart';
import '../utils/lifecycle_label.dart';
import '../utils/time_formatter.dart';

/// A purely presentational counter screen shared by both implementations.
///
/// It imports nothing from `getx/` or `riverpod/`: every value arrives as a
/// parameter and every interaction leaves as a callback. Both screens therefore
/// render the same layout, so any difference the user perceives comes from the
/// state-management layer and not from the UI.
class CounterView extends StatelessWidget {
  const CounterView({
    super.key,
    required this.implementationName,
    required this.implementationIcon,
    required this.stateManagementSummary,
    required this.accentColor,
    required this.counter,
    required this.elapsed,
    required this.timerStatus,
    required this.lifecycleState,
    required this.pausedByLifecycle,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.onStartTimer,
    required this.onPauseTimer,
    required this.onResumeTimer,
    required this.onStopTimer,
  });

  final String implementationName;
  final IconData implementationIcon;
  final String stateManagementSummary;
  final Color accentColor;

  final int counter;
  final Duration elapsed;
  final TimerStatus timerStatus;
  final AppLifecycleState lifecycleState;
  final bool pausedByLifecycle;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onStartTimer;
  final VoidCallback onPauseTimer;
  final VoidCallback onResumeTimer;
  final VoidCallback onStopTimer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('$implementationName Counter')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 20),
                  _buildCounterCard(theme),
                  const SizedBox(height: 16),
                  _buildTimerCard(theme),
                  const SizedBox(height: 16),
                  _buildLifecycleCard(theme),
                  const SizedBox(height: 20),
                  Text(
                    stateManagementSummary,
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

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(implementationIcon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 12),
            _StatusPill(label: implementationName, color: accentColor),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Interactive Counter',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Counter controls, an automatic timer and application lifecycle handling.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildCounterCard(ThemeData theme) {
    return _SurfaceCard(
      child: Column(
        children: [
          Text(
            'CURRENT COUNT',
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.6,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                  ),
                  child: child,
                ),
              );
            },
            child: Text(
              '$counter',
              key: ValueKey<int>(counter),
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 88,
                height: 1.05,
                fontWeight: FontWeight.w700,
                color: accentColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            counter == 0
                ? 'Decrement is disabled at the minimum value (0).'
                : 'Value changes animate for immediate visual feedback.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.tonalIcon(
                onPressed: counter > 0 ? onDecrement : null,
                icon: const Icon(Icons.remove_rounded),
                label: const Text('Decrement'),
              ),
              TextButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset'),
              ),
              FilledButton.icon(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Increment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard(ThemeData theme) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Automatic Counter',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              _StatusPill(label: timerStatus.label, color: _timerColor(timerStatus)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ELAPSED TIME',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatElapsed(elapsed),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '+1 / second',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: timerStatus.canStart ? onStartTimer : null,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start'),
              ),
              OutlinedButton.icon(
                onPressed: timerStatus.canPause ? onPauseTimer : null,
                icon: const Icon(Icons.pause_rounded),
                label: const Text('Pause'),
              ),
              OutlinedButton.icon(
                onPressed: timerStatus.canResume ? onResumeTimer : null,
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('Resume'),
              ),
              TextButton.icon(
                onPressed: timerStatus.canStop ? onStopTimer : null,
                style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                icon: const Icon(Icons.stop_rounded),
                label: const Text('Stop'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Stop cancels the timer and resets elapsed time. The counter value is always kept.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifecycleCard(ThemeData theme) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phonelink_ring_rounded, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Application Lifecycle',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              _StatusPill(
                label: lifecycleLabel(lifecycleState),
                color: lifecycleState == AppLifecycleState.resumed
                    ? const Color(0xFF15803D)
                    : const Color(0xFFB45309),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'The timer pauses automatically when the app leaves the foreground and the current '
            'count is preserved. It never restarts on its own, so returning to the app can never '
            'create a second timer.',
            style: theme.textTheme.bodyMedium,
          ),
          if (pausedByLifecycle) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFB45309)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Timer paused automatically in the background. Tap Resume to continue.',
                      style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Color _timerColor(TimerStatus status) {
  return switch (status) {
    TimerStatus.running => const Color(0xFF15803D),
    TimerStatus.paused => const Color(0xFFB45309),
    TimerStatus.stopped => const Color(0xFF64748B),
  };
}

/// Rounded white surface used for every section card.
class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
