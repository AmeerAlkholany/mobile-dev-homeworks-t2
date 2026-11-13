import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/counter_view.dart';
import '../controllers/counter_controller.dart';

/// GetX implementation of the counter screen.
///
/// A single [Obx] wraps the screen: every reactive variable read inside the
/// builder (`counter`, `elapsedSeconds`, `timerStatus`, ...) is tracked by GetX,
/// so any change rebuilds only this widget.
class GetxCounterPage extends GetView<CounterController> {
  const GetxCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final CounterController state = controller;

      return CounterView(
        implementationName: 'GetX',
        implementationIcon: Icons.bolt_rounded,
        stateManagementSummary: 'State: GetxController + Rx variables → Obx rebuilds',
        accentColor: AppTheme.getxAccent,
        counter: state.counter.value,
        elapsed: Duration(seconds: state.elapsedSeconds.value),
        timerStatus: state.timerStatus.value,
        lifecycleState: state.lifecycleState.value,
        pausedByLifecycle: state.pausedByLifecycle.value,
        onIncrement: state.increment,
        onDecrement: state.decrement,
        onReset: state.resetCounter,
        onStartTimer: state.startTimer,
        onPauseTimer: state.pauseTimer,
        onResumeTimer: state.resumeTimer,
        onStopTimer: state.stopTimer,
      );
    });
  }
}
