import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/counter_notifier.dart';

/// Riverpod provider exposing [CounterNotifier] to the widget tree.
///
/// `autoDispose` ties the notifier (and therefore its timer) to the lifetime of
/// the screen: when the Riverpod page is popped and nothing listens any more,
/// the provider is disposed and `ref.onDispose` cancels the timer.
final counterProvider = NotifierProvider.autoDispose<CounterNotifier, CounterState>(
  CounterNotifier.new,
);
