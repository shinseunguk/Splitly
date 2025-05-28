import 'package:flutter/material.dart';

class ScoreManageView extends StatelessWidget {
  const ScoreManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스코어 관리'), backgroundColor: Colors.blue),
      body: const Center(child: Text('스코어 관리 페이지')),
    );
  }
}
