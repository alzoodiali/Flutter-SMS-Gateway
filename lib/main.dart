import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/services/network_service.dart';
import 'core/services/storage_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => NetworkService().init());

  final token = await storageService.getToken();
  final initialRoute = (token != null && token.isNotEmpty) ? '/dashboard' : '/register';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SMS Gateway App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
