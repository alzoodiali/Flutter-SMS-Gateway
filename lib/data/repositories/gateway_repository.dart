import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/network_service.dart';
import '../models/sms_job.dart';

class GatewayRepository {
  final NetworkService _network = Get.find<NetworkService>();

  Future<Map<String, dynamic>> register({
    required String deviceId,
    required String name,
    String? phoneNumber,
    int simSlot = 1,
  }) async {
    final response = await _network.post(ApiConstants.registerGateway, data: {
      'device_id': deviceId,
      'name': name,
      'phone_number': phoneNumber,
      'sim_slot': simSlot,
    });
    return response.data;
  }

  Future<bool> authenticate() async {
    try {
      final response = await _network.post(ApiConstants.authenticateGateway);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendHeartbeat({int? batteryLevel, int? signalStrength}) async {
    await _network.post(ApiConstants.heartbeat, data: {
      'battery_level': batteryLevel,
      'signal_strength': signalStrength,
    });
  }

  Future<SmsJob?> getNextJob() async {
    final response = await _network.post(ApiConstants.nextJob);
    if (response.data['data'] != null) {
      return SmsJob.fromJson(response.data['data']);
    }
    return null;
  }

  Future<void> updateJobResult({
    required int jobId,
    required String status,
    String? errorMessage,
  }) async {
    await _network.post(ApiConstants.jobResult(jobId), data: {
      'status': status,
      'error_message': errorMessage,
    });
  }
}
