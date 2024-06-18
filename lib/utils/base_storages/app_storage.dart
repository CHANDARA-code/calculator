import '../storage_adapters/base_storage_adapter.dart';
import '../storage_adapters/share_preference_storage_adapter.dart';

class AppStorage {
  static BaseStorageAdapter? _preferenceAdapter;
  static BaseStorageAdapter? _secureAdapter;
  static BaseStorageAdapter get preferenceAdapter {
    if (_preferenceAdapter != null) return _preferenceAdapter!;
    _preferenceAdapter = SharedPreferenceStorageAdapter();
    return _preferenceAdapter!;
  }

  static set preferenceAdapter(BaseStorageAdapter storageAdapter) {
    _preferenceAdapter = storageAdapter;
  }

  static BaseStorageAdapter get secureAdapter {
    if (_secureAdapter != null) return _secureAdapter!;
    _secureAdapter = SharedPreferenceStorageAdapter();
    return _secureAdapter!;
  }

  static set secureAdapter(BaseStorageAdapter storageAdapter) {
    _secureAdapter = storageAdapter;
  }
}
