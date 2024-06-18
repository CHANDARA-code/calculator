import 'dart:convert';

import 'app_storage.dart';

abstract class BaseListStorage {
  Future<List<dynamic>?> read() async {
    String? string = await AppStorage.secureAdapter.readString(key: key());
    if (string == null) return null;
    List<dynamic> list = jsonDecode(string);
    return list;
  }

  write(List<dynamic> value) async {
    String string = jsonEncode(value);
    await AppStorage.secureAdapter.writeString(key: key(), value: string);
  }

  clear() async {
    await AppStorage.secureAdapter.delete(key: key());
  }

  String key();
}
