import 'package:flutter/material.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Categories')), body: const Center(child: Text('Category List')));
  }
}
