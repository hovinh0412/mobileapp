import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Transaction Detail')), body: const Center(child: Text('Detail')));
  }
}
