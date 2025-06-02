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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver에 구독
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void initState() {
    super.initState();
    // 5초마다 반복 호출되는 함수 예시
    _startPeriodicFunction();
  }

  void _startPeriodicFunction() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      _viewModel.fetchTeams();
      return true;
    });
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
                    final chartWidth =
                        constraints.maxWidth > 500
                            ? 500.0
                            : constraints.maxWidth;
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
                                  if (idx < 0 || idx >= teams.length)
                                    return Container();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: Text(
                                      teams[idx].teamName,
                                      style: const TextStyle(
                                        fontSize: 14,
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
                        ),
                        swapAnimationDuration: const Duration(
                          milliseconds: 2000,
                        ),
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
