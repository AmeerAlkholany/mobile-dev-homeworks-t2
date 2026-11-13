/// The three states of the automatic counter timer.
///
/// This is a plain domain type (no package imports) so both the GetX and the
/// Riverpod implementations can share the same vocabulary without sharing any
/// state-management code.
enum TimerStatus {
  stopped('Stopped'),
  running('Running'),
  paused('Paused');

  const TimerStatus(this.label);

  /// Human readable label shown in the status indicator.
  final String label;

  bool get canStart => this == TimerStatus.stopped;
  bool get canPause => this == TimerStatus.running;
  bool get canResume => this == TimerStatus.paused;
  bool get canStop => this != TimerStatus.stopped;
}
