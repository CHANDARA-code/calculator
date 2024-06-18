import 'package:caculator_app/notifier/calculator/calculator_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(calculatorProvider).history;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              history[index],
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
