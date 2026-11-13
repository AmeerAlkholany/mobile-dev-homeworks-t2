import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/riverpod/controllers/counter_notifier.dart';
import 'package:flutter_application_1/riverpod/providers/counter_provider.dart';
import 'package:flutter_application_1/shared/models/timer_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterState', () {
    test('copyWith replaces only the supplied fields', () {
      const CounterState initial = CounterState(counter: 2, elapsedSeconds: 5);
      final CounterState updated = initial.copyWith(counter: 3);

      expect(updated.counter, 3);
      expect(updated.elapsedSeconds, 5);
      expect(updated.timerStatus, TimerStatus.stopped);
    });

    test('states with equal values are equal', () {
      expect(const CounterState(counter: 4), const CounterState(counter: 4));
      expect(const CounterState(counter: 4), isNot(const CounterState(counter: 5)));
    });
  });

  group('counter controls', () {
    test('increment, decrement and reset', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      // A listener keeps the autoDispose provider alive for the test.
      container.listen(counterProvider, (_, _) {});
      final CounterNotifier notifier = container.read(counterProvider.notifier);

      notifier.increment();
      notifier.increment();
      notifier.increment();
      expect(container.read(counterProvider).counter, 3);

      notifier.decrement();
      expect(container.read(counterProvider).counter, 2);

      notifier.resetCounter();
      expect(container.read(counterProvider).counter, 0);
    });

    test('decrement never goes below zero', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(counterProvider, (_, _) {});
      final CounterNotifier notifier = container.read(counterProvider.notifier);

      notifier.decrement();
      notifier.decrement();

      expect(container.read(counterProvider).counter, 0);
    });
  });

  group('timer', () {
    test('ticks once per second, pauses, resumes and stops', () {
      fakeAsync((FakeAsync async) {
        final ProviderContainer container = ProviderContainer();
        container.listen(counterProvider, (_, _) {});
        final CounterNotifier notifier = container.read(counterProvider.notifier);

        notifier.startTimer();
        async.elapse(const Duration(seconds: 3));
        expect(container.read(counterProvider).counter, 3);
        expect(container.read(counterProvider).elapsedSeconds, 3);
        expect(container.read(counterProvider).timerStatus, TimerStatus.running);

        notifier.pauseTimer();
        async.elapse(const Duration(seconds: 2));
        expect(container.read(counterProvider).counter, 3);
        expect(container.read(counterProvider).timerStatus, TimerStatus.paused);

        notifier.resumeTimer();
        async.elapse(const Duration(seconds: 2));
        expect(container.read(counterProvider).counter, 5);
        expect(container.read(counterProvider).elapsedSeconds, 5);

        notifier.stopTimer();
        async.elapse(const Duration(seconds: 2));
        expect(container.read(counterProvider).timerStatus, TimerStatus.stopped);
        expect(container.read(counterProvider).elapsedSeconds, 0);
        expect(container.read(counterProvider).counter, 5);

        container.dispose();
      });
    });

    test('starting twice does not create a second timer', () {
      fakeAsync((FakeAsync async) {
        final ProviderContainer container = ProviderContainer();
        container.listen(counterProvider, (_, _) {});
        final CounterNotifier notifier = container.read(counterProvider.notifier);

        notifier.startTimer();
        notifier.startTimer();
        notifier.resumeTimer();

        async.elapse(const Duration(seconds: 2));
        expect(container.read(counterProvider).counter, 2);

        container.dispose();
      });
    });

    test('backgrounding pauses the timer and preserves the counter', () {
      fakeAsync((FakeAsync async) {
        final ProviderContainer container = ProviderContainer();
        container.listen(counterProvider, (_, _) {});
        final CounterNotifier notifier = container.read(counterProvider.notifier);

        notifier.startTimer();
        async.elapse(const Duration(seconds: 2));

        notifier.onAppLifecycleChanged(AppLifecycleState.paused);
        async.elapse(const Duration(seconds: 5));

        expect(container.read(counterProvider).counter, 2);
        expect(container.read(counterProvider).timerStatus, TimerStatus.paused);
        expect(container.read(counterProvider).pausedByLifecycle, isTrue);
        expect(container.read(counterProvider).lifecycleState, AppLifecycleState.paused);

        notifier.onAppLifecycleChanged(AppLifecycleState.resumed);
        async.elapse(const Duration(seconds: 2));
        expect(container.read(counterProvider).counter, 2);
        expect(container.read(counterProvider).lifecycleState, AppLifecycleState.resumed);

        notifier.resumeTimer();
        async.elapse(const Duration(seconds: 1));
        expect(container.read(counterProvider).counter, 3);

        container.dispose();
      });
    });

    test('disposing the provider cancels the timer and blocks late writes', () {
      fakeAsync((FakeAsync async) {
        final ProviderContainer container = ProviderContainer();
        container.listen(counterProvider, (_, _) {});
        container.read(counterProvider.notifier).startTimer();

        async.elapse(const Duration(seconds: 1));
        expect(container.read(counterProvider).counter, 1);

        container.dispose();

        // Would throw "Cannot use ref after dispose" if the timer survived.
        async.elapse(const Duration(seconds: 5));
      });
    });

    test('a new container starts from a clean state', () {
      fakeAsync((FakeAsync async) {
        final ProviderContainer first = ProviderContainer();
        first.listen(counterProvider, (_, _) {});
        first.read(counterProvider.notifier).startTimer();
        async.elapse(const Duration(seconds: 2));
        expect(first.read(counterProvider).counter, 2);
        first.dispose();

        final ProviderContainer second = ProviderContainer();
        second.listen(counterProvider, (_, _) {});
        expect(second.read(counterProvider).counter, 0);
        expect(second.read(counterProvider).timerStatus, TimerStatus.stopped);
        second.dispose();
      });
    });
  });
}
