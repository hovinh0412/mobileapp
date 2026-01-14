import 'package:flutter/material.dart';
import 'package:get/get.dart';

// SỬA DÒNG NÀY: Import đúng file main_screen.dart
import 'modules/main_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Manager',
      
      // Cập nhật Theme màu vàng luôn cho đồng bộ với App
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFFD54F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD54F),
          primary: const Color(0xFFFFD54F), // Màu vàng chủ đạo
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFD54F),
          foregroundColor: Colors.black, // Chữ trên AppBar màu đen
        ),
      ),
      
      // Màn hình đầu tiên là MainScreen (Chứa thanh menu dưới đáy)
      home: const MainScreen(),
    );
  }
}