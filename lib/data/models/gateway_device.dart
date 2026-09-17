class GatewayDevice {
  final int? id;
  final String deviceId;
  final String name;
  final String? phoneNumber;
  final int simSlot;
  final String status;
  final int? batteryLevel;
  final int? signalStrength;

  GatewayDevice({
    this.id,
    required this.deviceId,
    required this.name,
    this.phoneNumber,
    this.simSlot = 1,
    this.status = 'offline',
    this.batteryLevel,
    this.signalStrength,
  });

  factory GatewayDevice.fromJson(Map<String, dynamic> json) {
    return GatewayDevice(
      id: json['id'],
      deviceId: json['device_id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      simSlot: json['sim_slot'] ?? 1,
      status: json['status'] ?? 'offline',
      batteryLevel: json['battery_level'],
      signalStrength: json['signal_strength'],
    );
  }
}
