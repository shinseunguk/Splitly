import 'package:fl_chart/fl_chart.dart';
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

  // @override
  // void dispose() {
  //   // RouteObserver 구독 해제
  //   routeObserver.unsubscribe(this);
  //   // 화면을 벗어나면 세로모드로 복원
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  // @override
  // void didPush() {
  //   // 화면에 진입할 때마다 호출
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   debugPrint('HomeView: didPush (진입)');
  // }

  // @override
  // void didPopNext() {
  //   // 다른 화면에서 다시 돌아올 때마다 호출
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   debugPrint('HomeView: didPopNext (진입)');
  // }

  // @override
  // void didPop() {
  //   // 이 화면에서 pop으로 벗어날 때 호출
  //   debugPrint('HomeView: didPop (벗어남)');
  // }

  // @override
  // void didPushNext() {
  //   // 이 화면에서 다른 화면으로 push될 때 호출
  //   debugPrint('HomeView: didPushNext (벗어남)');
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // 이 화면에서만 가로모드 고정
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    // 예시 데이터, 실제로는 ViewModel 등에서 받아올 수 있음
    final teamScores = [
      {'name': '불사조', 'score': 5},
      {'name': '무적함대', 'score': 2},
      {'name': '다크호스', 'score': 3},
      {'name': '불사조', 'score': 4},
      {'name': '무적함대', 'score': 2},
    ];
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chartWidth =
                      constraints.maxWidth > 500 ? 500.0 : constraints.maxWidth;
                  final chartHeight =
                      constraints.maxHeight > 320
                          ? 320.0
                          : constraints.maxHeight;
                  return SizedBox(
                    width: chartWidth,
                    height: chartHeight,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: [
                          for (int i = 0; i < teamScores.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY:
                                      (teamScores[i]['score'] as int)
                                          .toDouble(),
                                  color: Colors.blue,
                                  width: 32,
                                ),
                              ],
                              showingTooltipIndicators: [0],
                            ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 48,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= teamScores.length)
                                  return Container();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                  ), // 위아래 패딩
                                  child: Text(
                                    teamScores[idx]['name'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14, // 명시적 폰트 크기
                                      overflow: TextOverflow.visible, // 잘림 방지
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        minY: 0,
                        maxY:
                            teamScores
                                .map((e) => e['score'] as int)
                                .reduce((a, b) => a > b ? a : b) *
                            1.2,
                      ),
                      swapAnimationDuration: Duration(milliseconds: 2000),
                      swapAnimationCurve: Curves.easeInOut,
                    ),
                  );
                },
              ),
            ),
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
      ),
    );
  }
}
