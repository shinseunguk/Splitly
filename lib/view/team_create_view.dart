import 'package:flutter/material.dart';

class TeamCreateView extends StatelessWidget {
  const TeamCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('팀 생성'), backgroundColor: Colors.blue),
      body: const Center(child: Text('팀 생성 페이지')),
    );
  }
}
