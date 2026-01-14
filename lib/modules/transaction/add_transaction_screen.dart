import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/transaction.dart';
import '../../data/models/category.dart';
import '../../core/utils/category_helper.dart'; // Import Helper
import 'transaction_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TransactionController controller = Get.find<TransactionController>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  
  DateTime selectedDate = DateTime.now();
  bool isExpense = true;
  
  // Biến lưu danh mục đang chọn (Mặc định lấy cái đầu tiên của list Chi)
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh mục mặc định
    selectedCategory = CategoryHelper.expenseCategories[0];
  }

  // Hàm thay đổi loại Thu/Chi
  void _changeType(bool value) {
    setState(() {
      isExpense = value;
      // Khi đổi loại, phải chọn lại danh mục mặc định tương ứng
      if (isExpense) {
        selectedCategory = CategoryHelper.expenseCategories[0];
      } else {
        selectedCategory = CategoryHelper.incomeCategories[0];
      }
    });
  }

  // Hàm hiển thị BottomSheet để chọn danh mục
  void _showCategoryPicker() {
    // Lấy list tương ứng
    final List<Category> listToShow = isExpense 
        ? CategoryHelper.expenseCategories 
        : CategoryHelper.incomeCategories;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 350,
          child: Column(
            children: [
              const Text("Chọn danh mục", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 cột
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: listToShow.length,
                  itemBuilder: (context, index) {
                    final cat = listToShow[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                        Navigator.pop(context); // Đóng bảng chọn
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: cat.color.withOpacity(0.2),
                            child: Icon(cat.icon, color: cat.color),
                          ),
                          const SizedBox(height: 5),
                          Text(cat.name, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveTransaction() {
    if (amountController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập số tiền");
      return;
    }

    final newTransaction = Transaction(
      amount: double.parse(amountController.text),
      note: noteController.text.isEmpty ? selectedCategory.name : noteController.text,
      date: selectedDate,
      isExpense: isExpense,
      category: selectedCategory.id, // LƯU ID CỦA DANH MỤC ĐÃ CHỌN
    );

    controller.addTransaction(newTransaction);
    Get.back();
    Get.snackbar("Thành công", "Đã lưu giao dịch");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm giao dịch"),
        backgroundColor: isExpense ? Colors.red[100] : Colors.green[100],
      ),
      body: SingleChildScrollView( // Bọc để không bị che khi bàn phím hiện
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Chọn Thu/Chi
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Chi tiêu")),
                    selected: isExpense,
                    selectedColor: Colors.redAccent,
                    onSelected: (val) => _changeType(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Thu nhập")),
                    selected: !isExpense,
                    selectedColor: Colors.greenAccent,
                    onSelected: (val) => _changeType(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Số tiền
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số tiền",
                border: OutlineInputBorder(),
                suffixText: "đ",
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 3. CHỌN DANH MỤC (MỚI)
            InkWell(
              onTap: _showCategoryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: selectedCategory.color,
                      radius: 18,
                      child: Icon(selectedCategory.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      selectedCategory.name, 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Ghi chú
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Ghi chú (Tùy chọn)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 20),

            // 5. Chọn ngày
            ListTile(
              title: Text("Ngày: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
              leading: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                 DateTime? picked = await showDatePicker(
                    context: context, initialDate: selectedDate, 
                    firstDate: DateTime(2020), lastDate: DateTime(2030));
                 if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            const SizedBox(height: 30),

            // 6. Nút Lưu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isExpense ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveTransaction,
                child: const Text("LƯU", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}