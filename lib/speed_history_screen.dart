import 'package:flutter/material.dart';

class SpeedHistoryScreen extends StatelessWidget {
  final List<String> history;

  const SpeedHistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historie rychlosti'),
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

