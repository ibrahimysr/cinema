import 'package:hive_flutter/hive_flutter.dart';

abstract class StorageService {
  Future<void> init();
  Future<void> saveData(String key, dynamic value);
  Future<T?> getData<T>(String key);
  Future<void> removeData(String key);
  Future<void> clearAll();
}

class HiveStorageService implements StorageService {
  static const String authBoxName = 'auth_box';
  late Box _box;
  
  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(authBoxName);
  }
  
  @override
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }
  
  @override
  Future<T?> getData<T>(String key) async {
    return _box.get(key) as T?;
  }
  
  @override
  Future<void> removeData(String key) async {
    await _box.delete(key);
  }
  
  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
} 