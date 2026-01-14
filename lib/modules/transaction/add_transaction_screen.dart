import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/transaction.dart';
import '../../data/models/category.dart';
import '../../core/utils/category_helper.dart';
import 'transaction_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> with SingleTickerProviderStateMixin {
  final TransactionController controller = Get.find<TransactionController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Tạo bộ điều khiển cho 3 tab: Chi tiêu, Thu nhập, Chuyển khoản
    _tabController = TabController(length: 3, vsync: this);
  }

  // HÀM QUAN TRỌNG: Hiển thị popup nhập tiền sau khi chọn icon
  void _showInputModal(Category category) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Để popup full màn hình hoặc cao lên
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy lên khi phím hiện
            left: 16, right: 16, top: 16
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Tiêu đề: Icon + Tên danh mục đã chọn
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: category.color.withOpacity(0.2),
                    child: Icon(category.icon, color: category.color),
                  ),
                  const SizedBox(width: 10),
                  Text(category.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Nhập số tiền
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                autofocus: true, // Tự động bật bàn phím
                decoration: const InputDecoration(
                  labelText: "Số tiền",
                  border: OutlineInputBorder(),
                  suffixText: "đ",
                ),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 15),

              // 3. Nhập ghi chú
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: "Ghi chú",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 15),

              // 4. Chọn ngày (Đơn giản hóa)
              // Bạn có thể thêm DatePicker ở đây nếu muốn

              // 5. Nút Lưu
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD54F)), // Màu vàng
                  onPressed: () {
                    if (amountController.text.isEmpty) return;

                    final newTransaction = Transaction(
                      amount: double.parse(amountController.text),
                      note: noteController.text.isEmpty ? category.name : noteController.text,
                      date: selectedDate,
                      isExpense: category.isExpense,
                      category: category.id,
                    );

                    controller.addTransaction(newTransaction);
                    Get.back(); // Đóng Modal
                    Get.back(); // Quay về Home
                    Get.snackbar("Thành công", "Đã thêm giao dịch");
                  },
                  child: const Text("LƯU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Widget hiển thị lưới Icon
  Widget _buildCategoryGrid(List<Category> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 cột giống ảnh
        childAspectRatio: 0.8, // Tỉ lệ chiều cao/rộng
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return InkWell(
          onTap: () => _showInputModal(cat), // Bấm vào thì hiện popup nhập
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Vòng tròn xám bao quanh icon
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                child: Icon(cat.icon, color: Colors.grey[700], size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                cat.name, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Màu vàng đặc trưng
    const Color primaryYellow = Color(0xFFFFD54F); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryYellow,
        title: const Text("Thêm", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Hủy", style: TextStyle(color: Colors.black)),
        ),
        actions: const [
           // Icon góc phải (như ảnh)
           Padding(
             padding: EdgeInsets.only(right: 10),
             child: Icon(Icons.edit_note, color: Colors.black),
           )
        ],
        // PHẦN TAB BAR CHUYỂN ĐỔI
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Chi tiêu"),
            Tab(text: "Thu nhập"),
            Tab(text: "Chuyển khoản"),
          ],
        ),
      ),
      
      // Nội dung thay đổi theo Tab
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Lưới Chi tiêu
          _buildCategoryGrid(CategoryHelper.expenseCategories),
          
          // Tab 2: Lưới Thu nhập
          _buildCategoryGrid(CategoryHelper.incomeCategories),
          
          // Tab 3: Chuyển khoản (Tạm thời để trống)
          const Center(child: Text("Tính năng đang phát triển")),
        ],
      ),
    );
  }
}