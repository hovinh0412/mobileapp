
import 'package:flutter/material.dart';
import '../../data/models/category.dart';

class CategoryHelper {
  // 1. Danh sách các hạng mục Chi tiêu
  static List<Category> expenseCategories = [
    Category(id: 'food', name: 'Ăn uống', icon: Icons.fastfood, color: Colors.orange, isExpense: true),
    Category(id: 'transport', name: 'Đi lại', icon: Icons.directions_bus, color: Colors.blue, isExpense: true),
    Category(id: 'shopping', name: 'Mua sắm', icon: Icons.shopping_cart, color: Colors.pink, isExpense: true),
    Category(id: 'bill', name: 'Hóa đơn', icon: Icons.receipt_long, color: Colors.purple, isExpense: true),
  ];

  // 2. Danh sách các hạng mục Thu nhập
  static List<Category> incomeCategories = [
    Category(id: 'salary', name: 'Lương', icon: Icons.attach_money, color: Colors.green, isExpense: false),
    Category(id: 'bonus', name: 'Thưởng', icon: Icons.card_giftcard, color: Colors.teal, isExpense: false),
    Category(id: 'invest', name: 'Đầu tư', icon: Icons.show_chart, color: Colors.indigo, isExpense: false),
  ];

  // 3. Hàm tìm Category theo ID (Dùng để hiển thị lịch sử)
  static Category getCategoryById(String id) {
    // Tìm trong cả 2 list
    final all = [...expenseCategories, ...incomeCategories];
    return all.firstWhere(
      (cat) => cat.id == id,
      // Nếu không tìm thấy (lỗi) thì trả về icon mặc định
      orElse: () => Category(id: 'other', name: 'Khác', icon: Icons.help_outline, color: Colors.grey, isExpense: true),
    );
  }
}