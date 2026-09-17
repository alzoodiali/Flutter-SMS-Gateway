import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';
import '../../../core/services/sms_native_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/sms_job.dart';
import '../../../data/repositories/gateway_repository.dart';

class DashboardController extends GetxController {
  final GatewayRepository _repository = GatewayRepository();
  final StorageService _storage = Get.find<StorageService>();
  final SmsNativeService _smsNative = Get.put(SmsNativeService());
  final Battery _battery = Battery();

  final isRunning = false.obs;
  final totalSent = 0.obs;
  final totalFailed = 0.obs;
  final batteryLevel = 100.obs;
  final statusMessage = 'جاهز للتشغيل'.obs;
  final logs = <String>[].obs;

  Timer? _pollTimer;
  Timer? _heartbeatTimer;

  @override
  void onInit() {
    super.onInit();
    _initBattery();
    startGatewayService();
  }

  @override
  void onClose() {
    stopGatewayService();
    super.onClose();
  }

  void _initBattery() async {
    try {
      batteryLevel.value = await _battery.batteryLevel;
    } catch (_) {}
  }

  void startGatewayService() {
    if (isRunning.value) return;
    isRunning.value = true;
    statusMessage.value = 'الخدمة قيد التشغيل (جاري سحب المهام...)';
    addLog('تم تشغيل بوابة SMS.');

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) => _sendHeartbeat());
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _pollNextJob());

    _sendHeartbeat();
  }

  void stopGatewayService() {
    isRunning.value = false;
    _pollTimer?.cancel();
    _heartbeatTimer?.cancel();
    statusMessage.value = 'الخدمة متوقفة';
    addLog('تم إيقاف خدمة البوابة.');
  }

  Future<void> _sendHeartbeat() async {
    try {
      final level = await _battery.batteryLevel;
      batteryLevel.value = level;
      await _repository.sendHeartbeat(batteryLevel: level, signalStrength: 80);
    } catch (e) {
      addLog('خطأ في إرسال النبض: $e');
    }
  }

  Future<void> _pollNextJob() async {
    if (!isRunning.value) return;

    try {
      final job = await _repository.getNextJob();
      if (job != null) {
        addLog('تم استلام مهمة جديدة #${job.id} لـ ${job.phoneNumber}');
        await _processSmsJob(job);
      }
    } catch (e) {
      addLog('خطأ أثناء سحب المهام: $e');
    }
  }

  Future<void> _processSmsJob(SmsJob job) async {
    final simSlot = await _storage.getSimSlot();
    final SmsResult result = await _smsNative.sendSms(
      phoneNumber: job.phoneNumber,
      message: job.message,
      simSlot: simSlot,
    );

    if (result.success) {
      totalSent.value++;
      addLog('تم إرسال الرسالة بنجاح لـ ${job.phoneNumber}');
      await _repository.updateJobResult(jobId: job.id, status: 'sent');
    } else {
      totalFailed.value++;
      final err = result.errorMessage ?? 'فشل إرسال الرسالة عبر الهاتف';
      addLog('فشل الإرسال لـ ${job.phoneNumber}: $err');
      await _repository.updateJobResult(
        jobId: job.id,
        status: 'failed',
        errorMessage: err,
      );
    }
  }

  void addLog(String message) {
    final time = DateTime.now().toIso8601String().substring(11, 19);
    logs.insert(0, '[$time] $message');
    if (logs.length > 50) logs.removeLast();
  }

  Future<void> logout() async {
    stopGatewayService();
    await _storage.clearAll();
    Get.offAllNamed('/register');
  }
}
