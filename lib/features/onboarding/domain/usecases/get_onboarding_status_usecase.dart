import '../repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  const GetOnboardingStatusUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<bool> call() => _repository.isCompleted();
}
