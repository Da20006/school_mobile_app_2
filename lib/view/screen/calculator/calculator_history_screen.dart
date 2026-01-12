import 'package:flutter/material.dart';

class CalculatorHistoryScreen extends StatelessWidget {
  final List<String> history;

  const CalculatorHistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historie kalkulačky'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[history.length - 1 - index];
          return ListTile(
            title: Text(item),
          );
        },
      ),
    );
  }
}

