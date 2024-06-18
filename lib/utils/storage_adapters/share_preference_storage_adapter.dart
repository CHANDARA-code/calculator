import 'package:caculator_app/utils/storage_adapters/base_storage_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorageAdapter extends BaseStorageAdapter {
  SharedPreferenceStorageAdapter();
  @override
  Future<String?> readString({required String key}) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  @override
  Future<void> writeString({required String key, required String value}) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  @override
  Future<void> delete({String? key}) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove(key ?? '');
  }
}
