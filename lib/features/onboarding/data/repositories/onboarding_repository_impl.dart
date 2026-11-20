import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<bool> isCompleted() async => _localDataSource.isCompleted();

  @override
  Future<void> complete() => _localDataSource.markCompleted();
}
