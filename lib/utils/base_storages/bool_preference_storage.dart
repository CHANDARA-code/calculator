import 'app_storage.dart';

abstract class BoolPreferenceStorage {
  Future<void> setOn() async {
    setValue(true);
  }

  setOff() {
    setValue(false);
  }

  setValue(bool value) {
    String storeValue = (value == true) ? '1' : '0';

    try {
      AppStorage.preferenceAdapter.writeString(key: key(), value: storeValue);
    } catch (e) {
      print(e);
    }
  }

  reset() {
    AppStorage.preferenceAdapter.delete(key: key());
  }

  Future<bool> get on async {
    String? value = await AppStorage.preferenceAdapter.readString(key: key());
    return value == '1' ? true : false;
  }

  Future<bool> get off async {
    bool isOn = await on;
    return !isOn;
  }

  String key();
}
