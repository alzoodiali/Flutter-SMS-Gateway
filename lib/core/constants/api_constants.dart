class ApiConstants {
  static const String baseUrl = 'http://192.168.1.36:8000/api/v1'; // Default for Android Emulator to local backend
  
  static const String registerGateway = '/gateway/register';
  static const String authenticateGateway = '/gateway/authenticate';
  static const String heartbeat = '/gateway/heartbeat';
  static const String nextJob = '/gateway/jobs/next';
  static String jobResult(int id) => '/gateway/jobs/$id/result';
}
