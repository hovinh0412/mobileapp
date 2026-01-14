import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/category_helper.dart'; // <--- Thêm dòng này
import '../../data/models/category.dart';       // <--- Thêm dòng này
import '../statistic/statistic_screen.dart';
// Import Controller và Màn hình thêm mới
import '../transaction/transaction_controller.dart';
import '../transaction/add_transaction_screen.dart';

// Import các tiện ích (Utils)
import '../../core/utils/currency_helper.dart';
import '../../core/utils/date_helper.dart';

// Import Widget bảng tổng kết vừa tạo
import 'widgets/total_card.dart';

class HomeScreen extends StatelessWidget {
  // 1. Tiêm (Inject) Controller vào màn hình này
  // Get.put() sẽ khởi tạo Controller và chạy hàm onInit (load dữ liệu) ngay lập tức
  final TransactionController controller = Get.put(TransactionController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          // Thêm nút này vào
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Get.to(() => StatisticScreen());
            },
          )
        ],
      ),
      
      // Dùng Column để chia bố cục: Trên là Bảng tổng kết, Dưới là Danh sách
      body: Column(
        children: [
          // ------------------------------------------
          // PHẦN 1: BẢNG TỔNG KẾT (WIDGET RIÊNG)
          // ------------------------------------------
          TotalCard(),

          // ------------------------------------------
          // PHẦN 2: DANH SÁCH GIAO DỊCH
          // ------------------------------------------
          // Dùng Expanded để danh sách chiếm hết phần màn hình còn lại
          Expanded(
            child: Obx(() {
              // Trường hợp 1: Đang load dữ liệu
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Trường hợp 2: Danh sách trống
              if (controller.transactionList.isEmpty) {
                return const Center(
                  child: Text(
                    "Chưa có giao dịch nào.\nBấm nút + để thêm mới.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              // Trường hợp 3: Có dữ liệu -> Hiển thị list
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80), // Chừa chỗ cho nút FAB
                itemCount: controller.transactionList.length,
                itemBuilder: (context, index) {
                  final transaction = controller.transactionList[index];

                  // Widget hỗ trợ vuốt để xóa
                  return Dismissible(
                    // Key bắt buộc phải là duy nhất (ID của giao dịch)
                    key: ValueKey(transaction.id),
                    
                    // Chỉ vuốt từ phải sang trái
                    direction: DismissDirection.endToStart,
                    
                    // Giao diện nền màu đỏ khi vuốt
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    
                    // Xử lý logic khi vuốt xong
                    onDismissed: (direction) {
                      controller.deleteTransaction(transaction.id!);
                      Get.snackbar(
                        "Đã xóa",
                        "Giao dịch đã được xóa khỏi danh sách",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    
                    // Giao diện thẻ hiển thị thông tin
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        // SỬA ĐỔI LỚN NHẤT Ở ĐÂY:
                        leading: Builder(
                          builder: (context) {
                            // 1. Tìm danh mục dựa vào ID đã lưu (VD: "food")
                            Category cat = CategoryHelper.getCategoryById(transaction.category);
                            
                            // 2. Hiển thị Icon và Màu của danh mục đó
                            return CircleAvatar(
                              backgroundColor: cat.color.withOpacity(0.2), // Màu nền nhạt
                              child: Icon(cat.icon, color: cat.color),     // Icon đậm
                            );
                          },
                        ),
                        
                        title: Text(
                          transaction.note.isEmpty ? "Không ghi chú" : transaction.note,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        
                        // Hiển thị tên danh mục ở dòng dưới cùng cho rõ
                        subtitle: Text(
                          "${DateHelper.formatDate(transaction.date)} • ${CategoryHelper.getCategoryById(transaction.category).name}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        
                        trailing: Text(
                          '${transaction.isExpense ? '-' : '+'}${CurrencyHelper.format(transaction.amount)}',
                          style: TextStyle(
                            color: transaction.isExpense ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // Nút nổi thêm giao dịch
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Get.to(() => const AddTransactionScreen());
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}