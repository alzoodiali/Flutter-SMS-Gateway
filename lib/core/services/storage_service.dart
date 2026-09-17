import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyToken = 'gateway_token';
  static const String _keyDeviceId = 'device_id';
  static const String _keySimSlot = 'sim_slot';
  static const String _keyBaseUrl = 'base_url';

  Future<StorageService> init() async {
    return this;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  Future<String?> getDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  Future<void> saveSimSlot(int slot) async {
    await _storage.write(key: _keySimSlot, value: slot.toString());
  }

  Future<int> getSimSlot() async {
    final val = await _storage.read(key: _keySimSlot);
    return val != null ? int.parse(val) : 1;
  }

  Future<void> saveBaseUrl(String url) async {
    await _storage.write(key: _keyBaseUrl, value: url);
  }

  Future<String?> getBaseUrl() async {
    return await _storage.read(key: _keyBaseUrl);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
