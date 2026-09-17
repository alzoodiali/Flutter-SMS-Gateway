import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/dashboard/views/dashboard_view.dart';

class AppPages {
  static const initial = '/register';

  static final routes = [
    GetPage(
      name: '/register',
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: '/dashboard',
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController());
      }),
    ),
  ];
}
