import 'package:get/get.dart';

import '../../../properties/domain/entities/property_entity.dart';
import '../../domain/usecases/get_favorite_ids_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

/// Shared favorites state. Registered by the main shell binding so the home
/// feed, details screen and favorites tab stay in sync; `favoriteIds` is an
/// observable set read by `Obx` heart buttons.
class FavoritesController extends GetxController
    with StateMixin<List<PropertyEntity>> {
  FavoritesController(
    this._getFavorites,
    this._getFavoriteIds,
    this._toggleFavorite,
  );

  final GetFavoritesUseCase _getFavorites;
  final GetFavoriteIdsUseCase _getFavoriteIds;
  final ToggleFavoriteUseCase _toggleFavorite;

  final RxSet<String> favoriteIds = <String>{}.obs;

  bool _idsLoaded = false;
  bool _listLoaded = false;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await ensureIdsLoaded();
    await loadFavorites();
  }

  Future<void> ensureIdsLoaded() async {
    if (_idsLoaded) {
      return;
    }
    final List<String> ids = await _getFavoriteIds();
    favoriteIds.assignAll(ids);
    _idsLoaded = true;
  }

  Future<void> loadFavorites({bool showLoading = true}) async {
    if (showLoading) {
      change(null, status: RxStatus.loading());
    }
    try {
      final List<String> ids = await _getFavoriteIds();
      favoriteIds.assignAll(ids);
      _idsLoaded = true;
      final List<PropertyEntity> favorites = await _getFavorites();
      _listLoaded = true;
      change(
        favorites,
        status: favorites.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (_) {
      change(null, status: RxStatus.error('error_generic'.tr));
    }
  }

  bool isFavorite(String propertyId) => favoriteIds.contains(propertyId);

  /// Persists the toggle, keeps the observable set in sync and refreshes the
  /// favorites list when it has already been displayed.
  Future<bool> toggleFavorite(String propertyId) async {
    await ensureIdsLoaded();
    final bool added = await _toggleFavorite(propertyId);
    if (added) {
      favoriteIds.add(propertyId);
    } else {
      favoriteIds.remove(propertyId);
    }
    if (_listLoaded) {
      await loadFavorites(showLoading: false);
    }
    return added;
  }
}
