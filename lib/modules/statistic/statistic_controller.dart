import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/category.dart';
import '../../core/utils/category_helper.dart';
import '../transaction/transaction_controller.dart';

// Class nhỏ để chứa dữ liệu sau khi gom nhóm (Dùng để vẽ biểu đồ)
class CategoryStat {
  final String categoryName;
  final double amount;
  final Color color;
  final double percentage;

  CategoryStat({
    required this.categoryName,
    required this.amount,
    required this.color,
    required this.percentage,
  });
}

class StatisticController extends GetxController {
  // Lấy dữ liệu từ TransactionController đã có sẵn
  final TransactionController _transactionController = Get.find<TransactionController>();

  // Biến chứa danh sách thống kê để màn hình hiển thị
  var statList = <CategoryStat>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Lắng nghe: Khi danh sách giao dịch thay đổi -> Tự tính lại thống kê
    ever(_transactionController.transactionList, (_) => calculateStats());
    calculateStats(); // Tính lần đầu tiên
  }

  void calculateStats() {
    // 1. Lấy tất cả khoản CHI (Expense)
    final allExpenses = _transactionController.transactionList
        .where((t) => t.isExpense)
        .toList();

    if (allExpenses.isEmpty) {
      statList.clear();
      return;
    }

    // 2. Tính tổng chi tiêu
    double totalExpense = allExpenses.fold(0.0, (sum, item) => sum + item.amount);

    // 3. Gom nhóm theo Category ID
    // Map: Key là ID danh mục, Value là tổng tiền
    Map<String, double> group = {};
    for (var t in allExpenses) {
      if (group.containsKey(t.category)) {
        group[t.category] = group[t.category]! + t.amount;
      } else {
        group[t.category] = t.amount;
      }
    }

    // 4. Chuyển đổi từ Map sang List<CategoryStat>
    List<CategoryStat> result = [];
    group.forEach((key, value) {
      Category cat = CategoryHelper.getCategoryById(key);
      result.add(CategoryStat(
        categoryName: cat.name,
        amount: value,
        color: cat.color,
        percentage: (value / totalExpense) * 100, // Tính phần trăm
      ));
    });

    // Sắp xếp: Cái nào tốn nhiều tiền nhất đưa lên đầu
    result.sort((a, b) => b.amount.compareTo(a.amount));

    statList.assignAll(result);
  }
}