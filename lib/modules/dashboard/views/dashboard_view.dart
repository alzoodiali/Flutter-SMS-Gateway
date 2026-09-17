import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم - بوابة SMS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'تسجيل الخروج',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status Card
            Obx(() => Card(
                  color: controller.isRunning.value ? Colors.green.shade50 : Colors.red.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          controller.isRunning.value ? Icons.check_circle : Icons.pause_circle,
                          color: controller.isRunning.value ? Colors.green : Colors.red,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.isRunning.value ? 'الخدمة نشطة' : 'الخدمة متوقفة',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                controller.statusMessage.value,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: controller.isRunning.value,
                          onChanged: (val) {
                            if (val) {
                              controller.startGatewayService();
                            } else {
                              controller.stopGatewayService();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildStatCard('المرسلة', '${controller.totalSent.value}', Colors.green, Icons.send)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _buildStatCard('الفاشلة', '${controller.totalFailed.value}', Colors.red, Icons.error)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _buildStatCard('البطارية', '${controller.batteryLevel.value}%', Colors.blue, Icons.battery_charging_full)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('سجل العمليات (Logs):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            // Logs View
            Expanded(
              child: Obx(() => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: controller.logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            controller.logs[index],
                            style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 13),
                          ),
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
