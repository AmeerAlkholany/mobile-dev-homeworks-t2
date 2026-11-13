import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/getx/controllers/counter_controller.dart';
import 'package:flutter_application_1/shared/models/timer_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CounterController controller;

  setUp(() {
    // Get.put runs the controller's onInit (observer registration).
    controller = Get.put(CounterController());
  });

  tearDown(() {
    // Deletes the controller, which runs onClose and cancels the timer. If a
    // timer survived, the test binding would fail the test for a pending timer.
    Get.delete<CounterController>(force: true);
  });

  group('counter controls', () {
    test('starts at zero with the timer stopped', () {
      expect(controller.counter.value, 0);
      expect(controller.elapsedSeconds.value, 0);
      expect(controller.timerStatus.value, TimerStatus.stopped);
    });

    test('increment adds one per call', () {
      controller.increment();
      controller.increment();
      controller.increment();

      expect(controller.counter.value, 3);
    });

    test('decrement never goes below zero', () {
      controller.decrement();
      expect(controller.counter.value, 0);

      controller.increment();
      controller.increment();
      controller.decrement();

      expect(controller.counter.value, 1);
    });

    test('resetCounter returns the value to zero', () {
      controller.increment();
      controller.increment();
      controller.resetCounter();

      expect(controller.counter.value, 0);
    });
  });

  group('timer', () {
    testWidgets('increments the counter and elapsed time once per second', (tester) async {
      controller.startTimer();
      expect(controller.timerStatus.value, TimerStatus.running);

      await tester.pump(const Duration(seconds: 1));
      expect(controller.counter.value, 1);
      expect(controller.elapsedSeconds.value, 1);

      await tester.pump(const Duration(seconds: 2));
      expect(controller.counter.value, 3);
      expect(controller.elapsedSeconds.value, 3);

      controller.stopTimer();
    });

    testWidgets('pause keeps values and resume continues from them', (tester) async {
      controller.increment();
      controller.startTimer();
      await tester.pump(const Duration(seconds: 2));
      expect(controller.counter.value, 3);

      controller.pauseTimer();
      expect(controller.timerStatus.value, TimerStatus.paused);
      await tester.pump(const Duration(seconds: 4));
      expect(controller.counter.value, 3);
      expect(controller.elapsedSeconds.value, 2);

      controller.resumeTimer();
      await tester.pump(const Duration(seconds: 1));
      expect(controller.counter.value, 4);
      expect(controller.elapsedSeconds.value, 3);

      controller.stopTimer();
    });

    testWidgets('stop cancels the timer and resets only the timer state', (tester) async {
      controller.increment();
      controller.startTimer();
      await tester.pump(const Duration(seconds: 3));

      controller.stopTimer();
      expect(controller.timerStatus.value, TimerStatus.stopped);
      expect(controller.elapsedSeconds.value, 0);
      expect(controller.counter.value, 4);

      await tester.pump(const Duration(seconds: 3));
      expect(controller.counter.value, 4);
    });

    testWidgets('repeated start/resume calls never duplicate the timer', (tester) async {
      controller.startTimer();
      controller.startTimer();
      controller.resumeTimer();

      await tester.pump(const Duration(seconds: 2));

      expect(controller.counter.value, 2);
      controller.stopTimer();
    });

    testWidgets('backgrounding pauses the timer and preserves the counter', (tester) async {
      controller.startTimer();
      await tester.pump(const Duration(seconds: 2));
      expect(controller.counter.value, 2);

      controller.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(controller.lifecycleState.value, AppLifecycleState.paused);
      expect(controller.timerStatus.value, TimerStatus.paused);
      expect(controller.pausedByLifecycle.value, isTrue);

      await tester.pump(const Duration(seconds: 5));
      expect(controller.counter.value, 2);
      expect(controller.elapsedSeconds.value, 2);

      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(controller.lifecycleState.value, AppLifecycleState.resumed);

      // Returning to the foreground must not restart the timer by itself.
      await tester.pump(const Duration(seconds: 2));
      expect(controller.counter.value, 2);

      controller.resumeTimer();
      await tester.pump(const Duration(seconds: 1));
      expect(controller.counter.value, 3);
      expect(controller.timerStatus.value, TimerStatus.running);

      controller.stopTimer();
    });

    testWidgets('detached also stops the running timer', (tester) async {
      controller.startTimer();
      await tester.pump(const Duration(seconds: 1));

      controller.didChangeAppLifecycleState(AppLifecycleState.detached);
      await tester.pump(const Duration(seconds: 3));

      expect(controller.counter.value, 1);
      expect(controller.timerStatus.value, TimerStatus.paused);
    });
  });
}
