
import 'package:flutter/material.dart';
import '../../data/models/category.dart';

class CategoryHelper {
  // 1. Danh sách các hạng mục Chi tiêu
  static List<Category> expenseCategories = [
    Category(id: 'shopping', name: 'Mua sắm', icon: Icons.shopping_cart, color: Colors.blue, isExpense: true),
    Category(id: 'food', name: 'Đồ ăn', icon: Icons.restaurant, color: Colors.orange, isExpense: true),
    Category(id: 'phone', name: 'Điện thoại', icon: Icons.phone_iphone, color: Colors.blueGrey, isExpense: true),
    Category(id: 'entertainment', name: 'Giải trí', icon: Icons.mic, color: Colors.pink, isExpense: true),
    Category(id: 'education', name: 'Giáo dục', icon: Icons.book, color: Colors.brown, isExpense: true),
    Category(id: 'beauty', name: 'Sắc đẹp', icon: Icons.face, color: Colors.purple, isExpense: true),
    Category(id: 'sport', name: 'Thể thao', icon: Icons.pool, color: Colors.cyan, isExpense: true),
    Category(id: 'social', name: 'Xã hội', icon: Icons.people, color: Colors.teal, isExpense: true),
    Category(id: 'transport', name: 'Đi lại', icon: Icons.directions_bus, color: Colors.indigo, isExpense: true),
    Category(id: 'clothing', name: 'Quần áo', icon: Icons.checkroom, color: Colors.deepPurple, isExpense: true),
    Category(id: 'car', name: 'Ô tô', icon: Icons.directions_car, color: Colors.blueAccent, isExpense: true),
    Category(id: 'health', name: 'Sức khỏe', icon: Icons.medical_services, color: Colors.redAccent, isExpense: true),
    // ... Bạn có thể thêm tiếp cho đủ
  ];

  // 2. Danh sách các hạng mục Thu nhập
  static List<Category> incomeCategories = [
    Category(
      id: 'salary', 
      name: 'Lương', 
      icon: Icons.account_balance_wallet, // Icon cái ví/thẻ
      color: Colors.amber[700]!, // Màu vàng sậm giống ảnh Home
      isExpense: false
    ),
    Category(
      id: 'invest', 
      name: 'Khoản đầu tư', 
      icon: Icons.savings, // Icon heo đất/túi tiền
      color: Colors.pinkAccent, // Màu hồng giống ảnh Home
      isExpense: false
    ),
    Category(
      id: 'overtime', 
      name: 'Làm thêm', 
      icon: Icons.access_time, // Icon đồng hồ
      color: Colors.blue, 
      isExpense: false
    ),
    Category(
      id: 'bonus', 
      name: 'Tiền thưởng', 
      icon: Icons.card_giftcard, // Icon hộp quà
      color: Colors.teal, 
      isExpense: false
    ),
    Category(
      id: 'other', 
      name: 'Khác', 
      icon: Icons.apps, // Icon 4 ô vuông
      color: Colors.grey, 
      isExpense: false
    ),
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