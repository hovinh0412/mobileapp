import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/currency_helper.dart';
import '../transaction/transaction_controller.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedTab = 0;
  final TransactionController controller = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD54F),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 1. THANH TAB
          Container(
            color: const Color(0xFFFFD54F),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.black : const Color(0xFFFFD54F),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                        ),
                        child: Text(
                          "Phân tích",
                          style: TextStyle(
                            color: _selectedTab == 0 ? const Color(0xFFFFD54F) : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.black : const Color(0xFFFFD54F),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                        ),
                        child: Text(
                          "Tài khoản",
                          style: TextStyle(
                            color: _selectedTab == 1 ? const Color(0xFFFFD54F) : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. NỘI DUNG
          Expanded(
            child: _selectedTab == 0 
                ? _buildAnalysisTab() 
                : const Center(child: Text("Tính năng Tài khoản đang phát triển")),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // CARD 1: THỐNG KÊ HÀNG THÁNG
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Thống kê hàng tháng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 15),
                
                // --- SỬA CHỖ NÀY: Dùng Obx bọc cả hàng ---
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Thg ${DateTime.now().month}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Chi tiêu", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          CurrencyHelper.format(controller.totalExpense),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Thu nhập", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          CurrencyHelper.format(controller.totalIncome),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // CARD 2: NGÂN SÁCH
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ngân sách hàng tháng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: 70, height: 70,
                      child: Stack(
                        children: [
                          const SizedBox(
                            width: 70, height: 70,
                            child: CircularProgressIndicator(value: 0, backgroundColor: Colors.grey, strokeWidth: 8),
                          ),
                          Center(child: Text("--", style: TextStyle(color: Colors.grey[600], fontSize: 20)))
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // --- SỬA CHỖ NÀY: Dùng Obx bọc cả cột ---
                    Expanded(
                      child: Obx(() => Column(
                        children: [
                           _buildBudgetRow("Còn lại :", 0 - controller.totalExpense),
                           const SizedBox(height: 8),
                           _buildBudgetRow("Ngân sách :", 0),
                           const SizedBox(height: 8),
                           _buildBudgetRow("Chi tiêu :", controller.totalExpense),
                        ],
                      )),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SỬA CHỖ NÀY: Xóa Obx ở trong hàm này đi ---
  Widget _buildBudgetRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text( // Không dùng Obx ở đây nữa
          CurrencyHelper.format(amount), 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}