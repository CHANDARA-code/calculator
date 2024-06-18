import 'dart:convert';

abstract class BaseStorageAdapter {
  Future<String?> readString({required String key});
  Future<void> delete({String key});

  Future<void> writeString({
    required String key,
    required String value,
  });

  writeObject(
      {required String key, required Map<String, dynamic> value}) async {
    String json = jsonEncode(value);
    await writeString(key: key, value: json);
  }

  Future<Map<String, dynamic>?> readObject({required String key}) async {
    String? json = await readString(key: key);
    if (json == null) return null;
    return jsonDecode(json);
  }
}
