import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitly/viewModel/team_score_view_model.dart';

class ScoreManageView extends StatefulWidget {
  const ScoreManageView({super.key});

  @override
  State<ScoreManageView> createState() => _ScoreManageViewState();
}

class _ScoreManageViewState extends State<ScoreManageView> {
  final TeamScoreViewModel _viewModel = Get.put(TeamScoreViewModel());
  RxInt? _openedIndex = RxInt(-1); // -1이면 아무것도 안 열림

  @override
  void initState() {
    super.initState();
    _viewModel.fetchTeamScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 스코어 관리'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('점수 초기화'),
                      content: const Text('정말로 모든 팀의 점수를 초기화 하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _viewModel.resetTeamScores();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_viewModel.errorMessage.isNotEmpty) {
          return Center(child: Text('에러: ${_viewModel.errorMessage.value}'));
        }
        final scores = _viewModel.teamScores.value;
        if (scores == null || scores.isEmpty) {
          return const Center(child: Text('팀 스코어 데이터가 없습니다.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: scores.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final team = scores[index];
            return Obx(
              () => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_openedIndex!.value == index) {
                        _openedIndex!.value = -1;
                      } else {
                        _openedIndex!.value = index;
                      }
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  team.teamName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '랭킹: ${team.teamRank == null ? '0' : team.teamRank}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '점수: ${team.teamScore}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '팀장: ${team.teamLeader}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '팀원: ${team.teamMembers.join(', ')}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (_openedIndex!.value == index) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final score in [10, 5, 3, 1])
                                    ElevatedButton(
                                      onPressed: () {
                                        _viewModel.changeTeamScore(
                                          team.teamId,
                                          score,
                                        );
                                      },
                                      child: Text('+$score'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final score in [10, 5, 3, 1])
                                    ElevatedButton(
                                      onPressed: () {
                                        _viewModel.changeTeamScore(
                                          team.teamId,
                                          -score,
                                        );
                                      },
                                      child: Text('-$score'),
                                    ),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: '직접입력',
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 8,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                      onSubmitted: (score) {
                                        final value = int.tryParse(score);
                                        if (value != null) {
                                          _viewModel.changeTeamScore(
                                            team.teamId,
                                            value,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
