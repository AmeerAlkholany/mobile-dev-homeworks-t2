import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';

abstract class OnboardingLocalDataSource {
  bool isCompleted();

  Future<void> markCompleted();
}

class OnboardingStorageDataSource implements OnboardingLocalDataSource {
  const OnboardingStorageDataSource(this._storage);

  final StorageService _storage;

  @override
  bool isCompleted() {
    return _storage.readBool(AppConstants.kOnboardingCompleted);
  }

  @override
  Future<void> markCompleted() {
    return _storage.writeBool(AppConstants.kOnboardingCompleted, true);
  }
}
