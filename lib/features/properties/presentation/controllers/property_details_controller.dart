import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/ui_helpers.dart';
import '../../../../routes/app_routes.dart';
import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/usecases/get_property_by_id_usecase.dart';

class PropertyDetailsController extends GetxController {
  PropertyDetailsController(this._getPropertyById, this.favorites);

  final GetPropertyByIdUseCase _getPropertyById;
  final FavoritesController favorites;

  final Rxn<PropertyEntity> property = Rxn<PropertyEntity>();
  final RxBool isLoading = true.obs;
  final RxString errorKey = ''.obs;
  final RxInt galleryIndex = 0.obs;

  String? _propertyId;

  @override
  void onInit() {
    super.onInit();
    final Object? arguments = Get.arguments;
    if (arguments is PropertyEntity) {
      _propertyId = arguments.id;
      property.value = arguments;
      isLoading.value = false;
    } else if (arguments is String) {
      _propertyId = arguments;
      load(arguments);
    } else {
      isLoading.value = false;
      errorKey.value = 'property_not_found';
    }
    if (_propertyId != null) {
      favorites.ensureIdsLoaded();
    }
  }

  Future<void> load(String id) async {
    _propertyId = id;
    isLoading.value = true;
    errorKey.value = '';
    try {
      property.value = await _getPropertyById(id);
    } catch (_) {
      property.value = null;
      errorKey.value = 'property_not_found';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reload() async {
    final String? id = _propertyId;
    if (id != null) {
      await load(id);
    }
  }

  void changeGalleryPage(int index) {
    galleryIndex.value = index;
  }

  Future<void> toggleFavorite() async {
    final PropertyEntity? current = property.value;
    if (current == null) {
      return;
    }
    final bool added = await favorites.toggleFavorite(current.id);
    Get.snackbar(
      added ? 'added_to_favorites'.tr : 'removed_from_favorites'.tr,
      current.title(isArabicLocale()),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void contactLandlord() {
    final PropertyEntity? current = property.value;
    if (current == null) {
      return;
    }
    Get.snackbar(
      current.landlordName(isArabicLocale()),
      current.landlordPhone,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void startBooking() {
    final PropertyEntity? current = property.value;
    if (current == null) {
      return;
    }
    Get.toNamed(AppRoutes.bookingFlow, arguments: current);
  }
}
