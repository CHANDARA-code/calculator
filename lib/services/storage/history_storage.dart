import 'package:caculator_app/utils/base_storages/base_storage.dart';

class HistoryStorage extends BaseStorage {
  @override
  String key() {
    return 'calculator_history';
  }
}
