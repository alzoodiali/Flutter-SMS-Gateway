import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SmsResult {
  final bool success;
  final String? errorMessage;

  SmsResult({required this.success, this.errorMessage});
}

class SmsNativeService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.example.sms_gateway_app/sms');

  Future<SmsResult> sendSms({
    required String phoneNumber,
    required String message,
    int simSlot = 1,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('sendSms', {
        'phone_number': phoneNumber,
        'message': message,
        'sim_slot': simSlot,
      });
      return SmsResult(success: result);
    } on PlatformException catch (e) {
      print('Failed to send SMS via MethodChannel: ${e.message}');
      return SmsResult(success: false, errorMessage: e.message ?? e.details?.toString() ?? 'خطأ في إرسال SMS عبر النظام');
    } catch (e) {
      return SmsResult(success: false, errorMessage: e.toString());
    }
  }

  Future<bool> requestSmsPermission() async {
    try {
      final bool granted = await _channel.invokeMethod('requestPermission');
      return granted;
    } on PlatformException catch (e) {
      print('Failed to request permission: ${e.message}');
      return false;
    }
  }
}
