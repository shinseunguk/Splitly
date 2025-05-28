import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitly/view/score_manage_view.dart';
import 'package:splitly/view/team_manage_view.dart';

class TeamMenuView extends StatefulWidget {
  const TeamMenuView({super.key});

  @override
  State<TeamMenuView> createState() => _TeamMenuViewState();
}

class _TeamMenuViewState extends State<TeamMenuView> {
  @override
  void initState() {
    super.initState();
    // 이 화면에서만 가로모드 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(''), backgroundColor: Colors.blue),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeamManageView(),
                    ),
                  );
                },
                child: const Text('팀 관리'),
              ),
            ),
            SizedBox(width: 24), // 두 버튼 사이 간격
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScoreManageView(),
                    ),
                  );
                },
                child: const Text('스코어 관리'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
