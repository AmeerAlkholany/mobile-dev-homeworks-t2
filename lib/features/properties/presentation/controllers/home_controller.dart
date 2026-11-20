import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/usecases/get_properties_usecase.dart';
import '../widgets/property_filters_sheet.dart';

/// Discovery controller: reactive search + filter state, `StateMixin` for the
/// async feed, and the shared favorites controller for heart toggles.
class HomeController extends GetxController
    with StateMixin<List<PropertyEntity>> {
  HomeController(this._getProperties, this.favorites);

  final GetPropertiesUseCase _getProperties;
  final FavoritesController favorites;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rxn<PropertyCategory> selectedCategory = Rxn<PropertyCategory>();
  final RxnString selectedCityKey = RxnString();
  final RxnDouble selectedMaxPrice = RxnDouble();

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    loadProperties();
  }

  bool get hasActiveFilters =>
      selectedCategory.value != null ||
      selectedCityKey.value != null ||
      selectedMaxPrice.value != null ||
      searchQuery.value.trim().isNotEmpty;

  Future<void> loadProperties() async {
    change(null, status: RxStatus.loading());
    try {
      final List<PropertyEntity> properties = await _getProperties(
        query: searchQuery.value,
        category: selectedCategory.value,
        cityKey: selectedCityKey.value,
        maxPrice: selectedMaxPrice.value,
      );
      change(
        properties,
        status: properties.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (_) {
      change(null, status: RxStatus.error('error_properties'.tr));
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), loadProperties);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    loadProperties();
  }

  void selectCategory(PropertyCategory? category) {
    if (selectedCategory.value == category) {
      return;
    }
    selectedCategory.value = category;
    loadProperties();
  }

  Future<void> openFilters(BuildContext context) async {
    final PropertyFilterSelection? selection =
        await showModalBottomSheet<PropertyFilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) => PropertyFiltersSheet(
        initialCityKey: selectedCityKey.value,
        initialMaxPrice: selectedMaxPrice.value,
      ),
    );
    if (selection == null) {
      return;
    }
    selectedCityKey.value = selection.cityKey;
    selectedMaxPrice.value = selection.maxPrice;
    await loadProperties();
  }

  Future<void> resetFilters() async {
    selectedCategory.value = null;
    selectedCityKey.value = null;
    selectedMaxPrice.value = null;
    searchQuery.value = '';
    searchController.clear();
    await loadProperties();
  }

  Future<void> toggleFavorite(String propertyId) {
    return favorites.toggleFavorite(propertyId);
  }

  void openDetails(String propertyId) {
    Get.toNamed(AppRoutes.propertyDetails, arguments: propertyId);
  }

  String get activeCityLabel =>
      selectedCityKey.value == null ? 'any_city'.tr : 'city_${selectedCityKey.value}'.tr;

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
