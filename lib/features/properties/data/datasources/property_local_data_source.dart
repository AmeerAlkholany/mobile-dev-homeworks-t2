import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/property_model.dart';
import 'property_mock_data.dart';

/// Contract for the property feed source. Kept abstract so tests can inject
/// fakes and a real API data source can be added later without touching the
/// repository or domain layers.
abstract class PropertyLocalDataSource {
  Future<List<PropertyModel>> fetchProperties();

  Future<PropertyModel> fetchPropertyById(String id);
}

/// Offline, realistic mock feed with a small simulated network delay so the
/// `StateMixin` loading states are visible.
class PropertyMockLocalDataSource implements PropertyLocalDataSource {
  const PropertyMockLocalDataSource();

  @override
  Future<List<PropertyModel>> fetchProperties() async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);
    return propertyMockData
        .map((Map<String, dynamic> json) => PropertyModel.fromJson(json))
        .toList();
  }

  @override
  Future<PropertyModel> fetchPropertyById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final Map<String, dynamic>? match = propertyMockData
        .cast<Map<String, dynamic>?>()
        .firstWhere(
          (Map<String, dynamic>? json) => json?['id'] == id,
          orElse: () => null,
        );
    if (match == null) {
      throw const NotFoundException('property_not_found');
    }
    return PropertyModel.fromJson(match);
  }
}
