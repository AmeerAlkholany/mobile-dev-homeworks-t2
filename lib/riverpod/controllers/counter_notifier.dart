import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/timer_status.dart';

/// Immutable snapshot of everything the Riverpod counter screen renders.
///
/// Every mutation produces a new instance through [copyWith], so the UI can
/// compare states with `==` and Riverpod only notifies when something changed.
@immutable
class CounterState {
  const CounterState({
    this.counter = 0,
    this.elapsedSeconds = 0,
    this.timerStatus = TimerStatus.stopped,
    this.lifecycleState = AppLifecycleState.resumed,
    this.pausedByLifecycle = false,
  });

  /// Current counter value. Never allowed to become negative.
  final int counter;

  /// Seconds accumulated by the automatic timer (reset by `stopTimer`).
  final int elapsedSeconds;

  final TimerStatus timerStatus;

  /// Latest [AppLifecycleState] forwarded by the screen's observer.
  final AppLifecycleState lifecycleState;

  /// True when the last pause was caused by the app leaving the foreground.
  final bool pausedByLifecycle;

  bool get canDecrement => counter > 0;

  CounterState copyWith({
    int? counter,
    int? elapsedSeconds,
    TimerStatus? timerStatus,
    AppLifecycleState? lifecycleState,
    bool? pausedByLifecycle,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      timerStatus: timerStatus ?? this.timerStatus,
      lifecycleState: lifecycleState ?? this.lifecycleState,
      pausedByLifecycle: pausedByLifecycle ?? this.pausedByLifecycle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CounterState &&
        other.counter == counter &&
        other.elapsedSeconds == elapsedSeconds &&
        other.timerStatus == timerStatus &&
        other.lifecycleState == lifecycleState &&
        other.pausedByLifecycle == pausedByLifecycle;
  }

  @override
  int get hashCode =>
      Object.hash(counter, elapsedSeconds, timerStatus, lifecycleState, pausedByLifecycle);

  @override
  String toString() => 'CounterState(counter: $counter, elapsedSeconds: $elapsedSeconds, '
      'timerStatus: ${timerStatus.name}, lifecycleState: ${lifecycleState.name}, '
      'pausedByLifecycle: $pausedByLifecycle)';
}

/// Riverpod 2.x `Notifier` holding the counter/timer logic for the second
/// implementation. It is created through `counterProvider`, never directly.
class CounterNotifier extends AutoDisposeNotifier<CounterState> {
  /// One tick per second: the counter increments and elapsed time advances.
  static const Duration tickInterval = Duration(seconds: 1);

  Timer? _timer;
  bool _disposed = false;

  @override
  CounterState build() {
    _disposed = false;
    // autoDispose means the provider is disposed when the screen is popped.
    // Cancelling here guarantees the periodic timer cannot outlive the state.
    ref.onDispose(() {
      _disposed = true;
      _cancelTimer();
    });
    return const CounterState();
  }

  // --- Counter controls -----------------------------------------------------

  void increment() => _emit(state.copyWith(counter: state.counter + 1));

  /// Decrements the counter, but floors it at zero.
  void decrement() {
    if (!state.canDecrement) return;
    _emit(state.copyWith(counter: state.counter - 1));
  }

  void resetCounter() => _emit(state.copyWith(counter: 0));

  // --- Timer controls -------------------------------------------------------

  /// Starts a stopped timer, or resumes it when it is paused.
  void startTimer() {
    if (state.timerStatus == TimerStatus.running) return; // Never a second timer.
    if (state.timerStatus == TimerStatus.paused) {
      resumeTimer();
      return;
    }
    _startTicking();
  }

  /// Pauses the timer without touching the counter or the elapsed time.
  void pauseTimer() {
    if (state.timerStatus != TimerStatus.running) return;
    _cancelTimer();
    _emit(state.copyWith(timerStatus: TimerStatus.paused, pausedByLifecycle: false));
  }

  /// Continues a paused timer from the values it already reached.
  void resumeTimer() {
    if (state.timerStatus != TimerStatus.paused) return;
    _startTicking();
  }

  /// Stops and disposes the timer, resetting the timer state (not the counter).
  void stopTimer() {
    _cancelTimer();
    _emit(state.copyWith(
      timerStatus: TimerStatus.stopped,
      elapsedSeconds: 0,
      pausedByLifecycle: false,
    ));
  }

  void _startTicking() {
    _cancelTimer(); // Defensive guard: at most one periodic timer exists.
    _emit(state.copyWith(timerStatus: TimerStatus.running, pausedByLifecycle: false));
    _timer = Timer.periodic(tickInterval, (_) {
      _emit(state.copyWith(
        counter: state.counter + 1,
        elapsedSeconds: state.elapsedSeconds + 1,
      ));
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Called by the screen when the framework reports a lifecycle change.
  void onAppLifecycleChanged(AppLifecycleState lifecycle) {
    // `hidden` is the desktop/web counterpart of being backgrounded.
    final bool leftForeground = lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.hidden ||
        lifecycle == AppLifecycleState.detached;
    final bool autoPaused = leftForeground && state.timerStatus == TimerStatus.running;

    if (autoPaused) {
      _cancelTimer();
    }

    // Deliberately no automatic resume on `resumed`: the user decides, which
    // keeps the behaviour predictable and guarantees no duplicate subscription.
    _emit(state.copyWith(
      lifecycleState: lifecycle,
      timerStatus: autoPaused ? TimerStatus.paused : state.timerStatus,
      pausedByLifecycle: autoPaused || state.pausedByLifecycle,
    ));
  }

  /// Single write path: ignores late callbacks after disposal.
  void _emit(CounterState next) {
    if (_disposed) return;
    state = next;
  }
}
