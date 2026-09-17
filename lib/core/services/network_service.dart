import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class NetworkService extends GetxService {
  late dio.Dio _dio;
  final StorageService _storage = Get.find<StorageService>();

  Future<NetworkService> init() async {
    final customUrl = await _storage.getBaseUrl();

    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: customUrl ?? ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    return this;
  }

  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
