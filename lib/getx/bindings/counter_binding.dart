import 'package:get/get.dart';

import '../controllers/counter_controller.dart';

/// GetX dependency injection for the counter feature.
///
/// `Get.to(..., binding: CounterBinding())` creates the controller when the
/// route is pushed and deletes it (calling `onClose`) when the route is popped,
/// so the observer and timer cannot leak.
class CounterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterController>(CounterController.new);
  }
}
