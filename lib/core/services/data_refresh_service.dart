import 'package:get/get.dart';

/// Broadcasts a revision counter whenever estate data (units, tenants or
/// payments) changes. Every list/dashboard controller listens and reloads, so
/// a payment recorded on one tab immediately refreshes dashboard totals.
class DataRefreshService extends GetxService {
  final RxInt revision = 0.obs;

  void notifyChanged() {
    revision.value++;
  }

  /// Helper that subscribes and returns a disposer for `onClose`.
  Worker listen(void Function(int revision) callback) {
    return ever<int>(revision, callback);
  }
}
