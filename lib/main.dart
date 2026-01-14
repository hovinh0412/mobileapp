import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/home/home_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Màn hình đầu tiên khi mở app là HomeScreen
      home: HomeScreen(),
    );
  }
}