import 'package:caculator_app/model/base/base_model.dart';

import 'base_storage.dart';

abstract class ObjectStorage extends BaseStorage {
  writeObject(BaseModel model) async {
    var serialized = serializeObject(model);
    await super.write(serialized);
  }

  Future<BaseModel?> readObject() async {
    var value = await super.read();
    BaseModel? unserialized;
    if (value != null) {
      unserialized = unserializeObject(value);
    }
    return unserialized;
  }

  Map<String, dynamic> serializeObject(BaseModel model);
  BaseModel unserializeObject(Map<String, dynamic> map);
}
