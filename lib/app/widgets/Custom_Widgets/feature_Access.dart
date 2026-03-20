import 'package:get/get.dart';

/// Generic controller to fetch any data of type T
/// Now supports persistent subscription state
class GenericController<T> extends GetxController {
  var data = Rxn<T>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Function to fetch data, must return T? (token handled internally)
  final Future<T?> Function() fetchFunction;

  /// Optional flag to prevent multiple loads
  bool _hasLoaded = false;

  GenericController({required this.fetchFunction});

  /// Call this to load data only once
  Future<void> loadData({bool forceReload = false}) async {
    // Skip if already loaded unless forceReload is true
    if (_hasLoaded && !forceReload) return;

    try {
      isLoading.value = true;

      final result = await fetchFunction();

      if (result != null) {
        data.value = result;
        _hasLoaded = true; // mark as loaded
      } else {
        errorMessage.value = 'Failed to fetch data.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset data if needed (for example, on logout)
  void reset() {
    data.value = null;
    errorMessage.value = '';
    _hasLoaded = false;
  }
}
