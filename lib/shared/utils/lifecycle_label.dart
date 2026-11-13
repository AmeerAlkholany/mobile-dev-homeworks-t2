import 'package:flutter/widgets.dart';

/// Maps a [AppLifecycleState] to the label shown in the lifecycle indicator.
///
/// Shared so both implementations display identical text for the same state.
String lifecycleLabel(AppLifecycleState? state) {
  switch (state) {
    case AppLifecycleState.resumed:
      return 'Resumed';
    case AppLifecycleState.inactive:
      return 'Inactive';
    case AppLifecycleState.hidden:
      return 'Hidden';
    case AppLifecycleState.paused:
      return 'Paused';
    case AppLifecycleState.detached:
      return 'Detached';
    case null:
      return 'Unknown';
  }
}
