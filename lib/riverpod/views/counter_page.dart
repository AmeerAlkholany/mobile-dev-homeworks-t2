import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/counter_view.dart';
import '../controllers/counter_notifier.dart';
import '../providers/counter_provider.dart';

/// Riverpod implementation of the counter screen.
///
/// A [ConsumerStatefulWidget] is used only because the screen must register
/// itself as a [WidgetsBindingObserver]; the reactive UI lives in
/// [_RiverpodCounterView], a [ConsumerWidget] that reads state with `ref.watch`.
class RiverpodCounterPage extends ConsumerStatefulWidget {
  const RiverpodCounterPage({super.key});

  @override
  ConsumerState<RiverpodCounterPage> createState() => _RiverpodCounterPageState();
}

class _RiverpodCounterPageState extends ConsumerState<RiverpodCounterPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Always remove the observer; the provider's own onDispose handles the timer.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ref.read: this is an action, not something this widget renders from.
    ref.read(counterProvider.notifier).onAppLifecycleChanged(state);
  }

  @override
  Widget build(BuildContext context) => const _RiverpodCounterView();
}

class _RiverpodCounterView extends ConsumerWidget {
  const _RiverpodCounterView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CounterState state = ref.watch(counterProvider);
    final CounterNotifier notifier = ref.read(counterProvider.notifier);

    return CounterView(
      implementationName: 'Riverpod',
      implementationIcon: Icons.auto_awesome_rounded,
      stateManagementSummary:
          'State: NotifierProvider.autoDispose → immutable CounterState → ref.watch',
      accentColor: AppTheme.riverpodAccent,
      counter: state.counter,
      elapsed: Duration(seconds: state.elapsedSeconds),
      timerStatus: state.timerStatus,
      lifecycleState: state.lifecycleState,
      pausedByLifecycle: state.pausedByLifecycle,
      onIncrement: notifier.increment,
      onDecrement: notifier.decrement,
      onReset: notifier.resetCounter,
      onStartTimer: notifier.startTimer,
      onPauseTimer: notifier.pauseTimer,
      onResumeTimer: notifier.resumeTimer,
      onStopTimer: notifier.stopTimer,
    );
  }
}
