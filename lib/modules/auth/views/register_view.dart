import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل بوابة SMS جديدة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.router, size: 80, color: Colors.indigo),
            const SizedBox(height: 20),
            const Text(
              'ربط الهاتف بالخادم كـ Gateway',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller.baseUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط Server API',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الجهاز',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الشريحة (اختياري)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sim_card),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() => DropdownButtonFormField<int>(
                  value: controller.simSlot.value,
                  decoration: const InputDecoration(
                    labelText: 'منفذ الشريحة (SIM Slot)',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('SIM 1')),
                    DropdownMenuItem(value: 2, child: Text('SIM 2')),
                  ],
                  onChanged: (val) => controller.simSlot.value = val ?? 1,
                )),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.registerGateway,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('تسجيل الجهاز والبدء', style: TextStyle(fontSize: 16)),
                )),
          ],
        ),
      ),
    );
  }
}
