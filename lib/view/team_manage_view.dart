import 'package:flutter/material.dart';
import 'package:splitly/view/team_create_view.dart';

class TeamManageView extends StatelessWidget {
  const TeamManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 관리'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamCreateView()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('팀 관리 페이지')),
    );
  }
}
