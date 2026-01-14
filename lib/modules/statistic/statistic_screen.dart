import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/currency_helper.dart';
import 'statistic_controller.dart';

class StatisticScreen extends StatelessWidget {
  final StatisticController controller = Get.put(StatisticController());

  StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thống kê chi tiêu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.statList.isEmpty) {
          return const Center(child: Text("Chưa có dữ liệu chi tiêu"));
        }

        return Column(
          children: [
            // PHẦN 1: BIỂU ĐỒ TRÒN
            SizedBox(
              height: 250, // Chiều cao biểu đồ
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2, // Khoảng cách giữa các miếng
                  centerSpaceRadius: 40, // Độ rỗng ở giữa (Tạo hình bánh Donut)
                  sections: controller.statList.map((stat) {
                    return PieChartSectionData(
                      color: stat.color,
                      value: stat.amount,
                      title: '${stat.percentage.toStringAsFixed(1)}%',
                      radius: 80, // Độ to của bán kính
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            const Divider(),

            // PHẦN 2: DANH SÁCH CHI TIẾT BÊN DƯỚI
            Expanded(
              child: ListView.builder(
                itemCount: controller.statList.length,
                itemBuilder: (context, index) {
                  final stat = controller.statList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: stat.color,
                      radius: 10,
                    ),
                    title: Text(stat.categoryName),
                    trailing: Text(
                      CurrencyHelper.format(stat.amount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: LinearProgressIndicator(
                      value: stat.percentage / 100,
                      backgroundColor: Colors.grey[200],
                      color: stat.color,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}