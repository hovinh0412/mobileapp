import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../transaction/transaction_controller.dart';
import '../../../core/utils/currency_helper.dart';

class TotalCard extends StatelessWidget {
  // Tìm Controller đang hoạt động để lấy số liệu
  final TransactionController controller = Get.find<TransactionController>();

  TotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Dùng Obx để khi số tiền thay đổi, widget này tự vẽ lại
    return Obx(() => Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dòng 1: Số dư tổng cộng
            const Text("Số dư hiện tại", style: TextStyle(color: Colors.grey)),
            Text(
              CurrencyHelper.format(controller.balance),
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                color: Colors.blueAccent
              ),
            ),
            const Divider(height: 30, thickness: 1),
            
            // Dòng 2: Chia đôi Thu và Chi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Cột Thu
                Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text("Thu nhập"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyHelper.format(controller.totalIncome),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                
                // Cột Chi
                Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text("Chi tiêu"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyHelper.format(controller.totalExpense),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}