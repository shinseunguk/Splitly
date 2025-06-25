import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:splitly/main.dart' show routeObserver;
import 'package:splitly/view/team_menu_view.dart.dart';
import 'package:splitly/viewModel/team_create_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  final TeamViewModel _viewModel = Get.put(TeamViewModel());
  int _infoButtonCounter = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 최초 1회 즉시 데이터 가져오기
    _viewModel.fetchTeams();
    // 5초마다 반복 호출되는 함수 예시
    _startPeriodicFunction();
  }

  @override
  void dispose() {
    _timer?.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _startPeriodicFunction() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        _viewModel.fetchTeams();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver에 구독
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPush() {
    // 화면에 진입할 때마다 타이머 시작
    _startPeriodicFunction();
  }

  @override
  void didPopNext() {
    // 다른 화면에서 다시 돌아올 때마다 타이머 시작
    _startPeriodicFunction();
  }

  @override
  void didPop() {
    // 이 화면에서 pop으로 벗어날 때 타이머 중지
    _timer?.cancel();
    debugPrint('HomeView: didPop (벗어남)');
  }

  @override
  void didPushNext() {
    // 이 화면에서 다른 화면으로 push될 때 타이머 중지
    _timer?.cancel();
    debugPrint('HomeView: didPushNext (벗어남)');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          // if (_viewModel.isLoading.value) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          if (_viewModel.errorMessage.isNotEmpty) {
            return Center(
              child: Text('에러: \\${_viewModel.errorMessage.value}'),
            );
          }
          final teams = _viewModel.selectResponse.value ?? [];
          if (teams.isEmpty) {
            return const Center(child: Text('팀 데이터가 없습니다.'));
          }
          return Stack(
            children: [
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 반응형 차트 크기 설정 (웹/모바일 대응)
                    final isWide = constraints.maxWidth > 700;
                    final chartWidth =
                        isWide
                            ? constraints.maxWidth * 0.7
                            : constraints.maxWidth * 0.95;
                    final chartHeight =
                        isWide
                            ? constraints.maxHeight * 0.7
                            : constraints.maxHeight * 0.45;
                    return SizedBox(
                      width: chartWidth,
                      height: chartHeight,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: [
                            for (int i = 0; i < teams.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY:
                                        (_viewModel
                                                    .selectResponse
                                                    .value?[i]
                                                    .teamScore ??
                                                0)
                                            .toDouble(),
                                    color: Colors.blue,
                                    width: isWide ? 48 : 32,
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
                                  if (idx < 0 || idx >= teams.length)
                                    return Container();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: Text(
                                      teams[idx].teamName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isWide ? 40 : 24, // 폰트 크기 증가
                                        overflow: TextOverflow.visible,
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
                          maxY: (teams
                                      .map((e) => e.teamScore)
                                      .reduce((a, b) => a > b ? a : b) *
                                  1.2)
                              .clamp(1.0, double.infinity), // 임시 maxY
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (
                                group,
                                groupIndex,
                                rod,
                                rodIndex,
                              ) {
                                return BarTooltipItem(
                                  rod.toY.toInt().toString(), // 소수점 없이 정수로 표시
                                  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28, // 글자 크게
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.easeInOut,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _infoButtonCounter++;
                      if (_infoButtonCounter == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamMenuView(),
                          ),
                        );
                        _infoButtonCounter = 0;
                      }
                    });
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
