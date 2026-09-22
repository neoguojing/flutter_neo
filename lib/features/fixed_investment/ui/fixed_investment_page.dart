import 'package:flutter/material.dart';

class FixedInvestmentPage extends StatelessWidget {
  const FixedInvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('定投计划'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('定投计划页面内容', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
