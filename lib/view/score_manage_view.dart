import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitly/model/score/team_score_model.dart';
import 'package:splitly/viewModel/team_score_view_model.dart';

class ScoreManageView extends StatefulWidget {
  const ScoreManageView({super.key});

  @override
  State<ScoreManageView> createState() => _ScoreManageViewState();
}

class _ScoreManageViewState extends State<ScoreManageView> {
  final TeamScoreViewModel _viewModel = Get.put(TeamScoreViewModel());
  final RxSet<int> _openedIndexes = <int>{}.obs;
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();
    _viewModel.fetchTeamScores();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showGameEndCelebration() {
    final scores = _viewModel.teamScores.value;
    if (scores == null || scores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('팀 데이터가 없습니다.')),
      );
      return;
    }
    final winner = scores.reduce(
      (a, b) => a.teamScore >= b.teamScore ? a : b,
    );
    _confettiController.play();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (dialogContext) => _GameEndDialog(
        winner: winner,
        confettiController: _confettiController,
        onClose: () {
          _confettiController.stop();
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _confirmGameEnd() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게임 종료'),
        content: const Text('게임을 종료하고 우승 팀을 공개하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showGameEndCelebration();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 스코어 관리'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            tooltip: '게임 종료',
            onPressed: _confirmGameEnd,
          ),
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
                      if (_openedIndexes.contains(index)) {
                        _openedIndexes.remove(index);
                      } else {
                        _openedIndexes.add(index);
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
                                    '랭킹: ${team.teamRank ?? 0}',
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
                            if (_openedIndexes.contains(index)) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final score in [5, 3, 2, 1])
                                    ElevatedButton(
                                      onPressed: () {
                                        _viewModel.updateTeamScore(
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
                                  for (final score in [5, 3, 2, 1])
                                    ElevatedButton(
                                      onPressed: () {
                                        _viewModel.updateTeamScore(
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
                                        hintText: 'plus',
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
                                          _viewModel.updateTeamScore(
                                            team.teamId,
                                            value,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: 'change',
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

class _GameEndDialog extends StatelessWidget {
  final TeamScoreModel winner;
  final ConfettiController confettiController;
  final VoidCallback onClose;

  const _GameEndDialog({
    required this.winner,
    required this.confettiController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 96),
                const SizedBox(height: 16),
                const Text(
                  '🎉 우승 팀 🎉',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                Text(
                  winner.teamName,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '최종 점수: ${winner.teamScore}점',
                  style: const TextStyle(fontSize: 22, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  '팀장: ${winner.teamLeader}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('닫기', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            maxBlastForce: 40,
            minBlastForce: 10,
            gravity: 0.2,
            shouldLoop: true,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.yellow,
              Colors.pink,
            ],
          ),
        ),
      ],
    );
  }
}
