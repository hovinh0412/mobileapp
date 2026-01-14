import '../../core/services/database_service.dart';
import '../models/transaction.dart';

class TransactionRepository {
  // Lấy instance của DatabaseService
  final DatabaseService _databaseService = DatabaseService();

  // 1. Hàm thêm giao dịch mới
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await _databaseService.database;
    // 'transactions' là tên bảng mình đã tạo ở Bước 2
    return await db.insert('transactions', transaction.toMap());
  }

  // 2. Hàm lấy tất cả giao dịch (Mới nhất lên đầu)
  Future<List<Transaction>> getAllTransactions() async {
    final db = await _databaseService.database;
    
    // Query lấy dữ liệu và sắp xếp theo ngày giảm dần (DESC)
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: "date DESC", 
    );

    // Chuyển đổi từ List<Map> sang List<Transaction>
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  // 3. Hàm xóa giao dịch
  Future<int> deleteTransaction(int id) async {
    final db = await _databaseService.database;
    return await db.delete(
      'transactions',
      where: 'id = ?', // Xóa tại dòng có id bằng...
      whereArgs: [id], // ... giá trị này
    );
  }

  // 4. Hàm cập nhật giao dịch (Ví dụ sửa số tiền)
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await _databaseService.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}