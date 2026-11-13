import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../shared/models/timer_status.dart';

/// State and business logic for the GetX implementation.
///
/// All UI-relevant values are exposed as reactive types ([RxInt], [Rx] for the
/// timer/lifecycle enums and [RxBool]); the view renders them through `Obx`.
///
/// The controller is a [WidgetsBindingObserver] so it can implement the
/// lifecycle requirement itself, which is why it must be created through
/// [CounterBinding] / `Get.put`: GetX then calls [onInit] to register the
/// observer and [onClose] to remove it together with the timer.
class CounterController extends GetxController with WidgetsBindingObserver {
  CounterController({this.tickInterval = const Duration(seconds: 1)});

  /// How often the timer ticks. Configurable for tests.
  final Duration tickInterval;

  /// Current counter value. Never allowed to become negative.
  final RxInt counter = 0.obs;

  /// Seconds accumulated by the automatic timer (reset by [stopTimer]).
  final RxInt elapsedSeconds = 0.obs;

  final Rx<TimerStatus> timerStatus = TimerStatus.stopped.obs;

  /// Latest [AppLifecycleState] reported by the framework.
  final Rx<AppLifecycleState> lifecycleState = AppLifecycleState.resumed.obs;

  /// True when the last pause was caused by the app leaving the foreground.
  final RxBool pausedByLifecycle = false.obs;

  Timer? _timer;

  bool get isRunning => timerStatus.value == TimerStatus.running;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    lifecycleState.value = WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }

  @override
  void onClose() {
    // Cancel first, then unregister: nothing may outlive the screen.
    _cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // --- Counter controls -----------------------------------------------------

  void increment() => counter.value++;

  /// Decrements the counter, but floors it at zero.
  void decrement() {
    if (counter.value > 0) {
      counter.value--;
    }
  }

  void resetCounter() => counter.value = 0;

  // --- Timer controls -------------------------------------------------------

  /// Starts a stopped timer, or resumes it when it is paused.
  void startTimer() {
    if (isRunning) return; // Idempotent: Start can never create a second timer.
    if (timerStatus.value == TimerStatus.paused) {
      resumeTimer();
      return;
    }
    _startTicking();
  }

  /// Pauses the timer without touching the counter or the elapsed time.
  void pauseTimer() {
    if (!isRunning) return;
    _cancelTimer();
    timerStatus.value = TimerStatus.paused;
    pausedByLifecycle.value = false;
  }

  /// Continues a paused timer from the values it already reached.
  void resumeTimer() {
    if (timerStatus.value != TimerStatus.paused) return;
    _startTicking();
  }

  /// Stops and disposes the timer, resetting the timer state (not the counter).
  void stopTimer() {
    _cancelTimer();
    timerStatus.value = TimerStatus.stopped;
    elapsedSeconds.value = 0;
    pausedByLifecycle.value = false;
  }

  void _startTicking() {
    _cancelTimer(); // Defensive guard: at most one periodic timer exists.
    timerStatus.value = TimerStatus.running;
    pausedByLifecycle.value = false;
    _timer = Timer.periodic(tickInterval, (_) {
      counter.value++;
      elapsedSeconds.value++;
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // --- Application lifecycle -----------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lifecycleState.value = state;

    // `hidden` is the desktop/web counterpart of being backgrounded.
    final bool leftForeground = state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached;

    if (leftForeground && isRunning) {
      _cancelTimer();
      timerStatus.value = TimerStatus.paused;
      // Deliberately no automatic resume: the user decides, which keeps the
      // behaviour predictable and guarantees no duplicate subscription.
      pausedByLifecycle.value = true;
    }
  }
}
