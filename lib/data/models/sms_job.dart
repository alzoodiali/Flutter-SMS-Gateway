class SmsJob {
  final int id;
  final String phoneNumber;
  final String message;
  final String type;
  final String status;
  final String? requestId;

  SmsJob({
    required this.id,
    required this.phoneNumber,
    required this.message,
    required this.type,
    required this.status,
    this.requestId,
  });

  factory SmsJob.fromJson(Map<String, dynamic> json) {
    return SmsJob(
      id: json['id'],
      phoneNumber: json['phone_number'],
      message: json['message'],
      type: json['type'] ?? 'otp',
      status: json['status'] ?? 'pending',
      requestId: json['request_id'],
    );
  }
}
