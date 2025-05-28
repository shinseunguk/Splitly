import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitly/main.dart' show routeObserver;
import 'package:splitly/view/team_menu_view.dart.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  int _infoButtonCounter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver에 구독
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    // RouteObserver 구독 해제
    routeObserver.unsubscribe(this);
    // 화면을 벗어나면 세로모드로 복원
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void didPush() {
    // 화면에 진입할 때마다 호출
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    debugPrint('HomeView: didPush (진입)');
  }

  @override
  void didPopNext() {
    // 다른 화면에서 다시 돌아올 때마다 호출
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    debugPrint('HomeView: didPopNext (진입)');
  }

  @override
  void didPop() {
    // 이 화면에서 pop으로 벗어날 때 호출
    debugPrint('HomeView: didPop (벗어남)');
  }

  @override
  void didPushNext() {
    // 이 화면에서 다른 화면으로 push될 때 호출
    debugPrint('HomeView: didPushNext (벗어남)');
  }

  @override
  void initState() {
    super.initState();
    // 이 화면에서만 가로모드 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Text('Welcome to Splitly!')),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.black),
              onPressed: () {
                setState(() {
                  _infoButtonCounter++;
                  if (_infoButtonCounter == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeamMenuView()),
                    );
                    _infoButtonCounter = 0; // 다시 초기화
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
