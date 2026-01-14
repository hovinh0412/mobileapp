import 'package:get/get.dart';
import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repo.dart';

class TransactionController extends GetxController {
  // 1. Khai báo Repository để dùng
  final TransactionRepository _transactionRepo = TransactionRepository();

  // 2. Biến chứa danh sách giao dịch (Dạng RxList để UI tự cập nhật)
  // ".obs" là tính năng của GetX, nghĩa là "Observable" (Có thể theo dõi được)
  var transactionList = <Transaction>[].obs;
  
  // Biến check xem có đang load dữ liệu không (để hiện vòng xoay loading)
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Khi Controller được tạo, load dữ liệu ngay lập tức
    loadTransactions();
  }

  // Hàm lấy dữ liệu từ Database
  void loadTransactions() async {
    isLoading.value = true; // Bật loading
    
    // Gọi Repository lấy list về
    var list = await _transactionRepo.getAllTransactions();
    
    // Gán vào biến transactionList
    transactionList.assignAll(list);
    
    isLoading.value = false; // Tắt loading
  }

  // Hàm thêm giao dịch mới
  Future<void> addTransaction(Transaction transaction) async {
    // 1. Gửi xuống Database lưu
    await _transactionRepo.insertTransaction(transaction);
    
    // 2. Load lại danh sách để màn hình cập nhật giao dịch mới vừa thêm
    loadTransactions(); 
  }

  // Hàm xóa giao dịch
  Future<void> deleteTransaction(int id) async {
    await _transactionRepo.deleteTransaction(id);
    loadTransactions();
  }
  // 1. Tính tổng thu (Lọc những cái không phải Expense -> cộng dồn lại)
  double get totalIncome => transactionList
      .where((item) => !item.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  // 2. Tính tổng chi
  double get totalExpense => transactionList
      .where((item) => item.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  // 3. Tính số dư
  double get balance => totalIncome - totalExpense;
}