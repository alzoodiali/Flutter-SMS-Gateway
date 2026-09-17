import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/gateway_repository.dart';

class AuthController extends GetxController {
  final GatewayRepository _repository = GatewayRepository();
  final StorageService _storage = Get.find<StorageService>();

  final nameController = TextEditingController(text: 'Xiaomi Gateway');
  final phoneController = TextEditingController(text: '967770000000');
  final baseUrlController = TextEditingController(text: 'http://10.0.2.2:8000/api/v1');
  final simSlot = 1.obs;
  final isLoading = false.obs;

  Future<void> registerGateway() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال اسم الجهاز');
      return;
    }

    isLoading.value = true;
    try {
      if (baseUrlController.text.trim().isNotEmpty) {
        await _storage.saveBaseUrl(baseUrlController.text.trim());
      }

      String? deviceId = await _storage.getDeviceId();
      deviceId ??= 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.saveDeviceId(deviceId);

      final response = await _repository.register(
        deviceId: deviceId,
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        simSlot: simSlot.value,
      );

      final token = response['data']['token'];
      await _storage.saveToken(token);
      await _storage.saveSimSlot(simSlot.value);

      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تسجيل الجهاز: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
