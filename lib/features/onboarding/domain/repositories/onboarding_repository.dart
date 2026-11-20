/// Access to the persisted first-launch flag.
abstract class OnboardingRepository {
  Future<bool> isCompleted();

  Future<void> complete();
}
