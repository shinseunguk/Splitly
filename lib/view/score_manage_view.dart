import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitly/view/widget/game_end_dialog.dart';
import 'package:splitly/viewModel/game_state_view_model.dart';
import 'package:splitly/viewModel/team_score_view_model.dart';

class ScoreManageView extends StatefulWidget {
  const ScoreManageView({super.key});

  @override
  State<ScoreManageView> createState() => _ScoreManageViewState();
}

class _ScoreManageViewState extends State<ScoreManageView> {
  static const Duration _pollInterval = Duration(seconds: 3);

  final TeamScoreViewModel _viewModel = Get.put(TeamScoreViewModel());
  final GameStateViewModel _gameStateViewModel = Get.put(GameStateViewModel());
  final RxSet<int> _openedIndexes = <int>{}.obs;
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  Timer? _pollingTimer;
  DateTime? _lastSeenEndedAt;
  bool _isCelebrationOpen = false;

  @override
  void initState() {
    super.initState();
    _viewModel.fetchTeamScores();
    _bootstrapGameState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _bootstrapGameState() async {
    await _gameStateViewModel.fetchGameState();
    // Seed the last-seen marker so the user isn't greeted by a stale celebration.
    _lastSeenEndedAt = _gameStateViewModel.gameState.value?.endedAt;
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(_pollInterval, (_) async {
      await _gameStateViewModel.fetchGameState();
      _handleGameStateChange(_gameStateViewModel.gameState.value?.endedAt);
    });
  }

  void _handleGameStateChange(DateTime? endedAt) {
    if (endedAt == null) {
      _lastSeenEndedAt = null;
      return;
    }
    if (_lastSeenEndedAt == endedAt) return;
    _lastSeenEndedAt = endedAt;
    _triggerCelebration();
  }

  void _triggerCelebration() {
    if (!mounted || _isCelebrationOpen) return;
    final scores = _viewModel.teamScores.value;
    if (scores == null || scores.isEmpty) return;
    final winner = scores.reduce(
      (a, b) => a.teamScore >= b.teamScore ? a : b,
    );
    _isCelebrationOpen = true;
    _confettiController.play();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (dialogContext) => GameEndDialog(
        teamName: winner.teamName,
        teamScore: winner.teamScore,
        teamLeader: winner.teamLeader,
        teamMembers: winner.teamMembers,
        confettiController: _confettiController,
        onClose: () {
          _confettiController.stop();
          Navigator.of(dialogContext).pop();
        },
      ),
    ).whenComplete(() {
      _isCelebrationOpen = false;
    });
  }

  Future<void> _onGameEndPressed() async {
    final isEnded = _gameStateViewModel.gameState.value?.isEnded ?? false;
    final confirmed = await _confirmToggle(isCurrentlyEnded: isEnded);
    if (confirmed != true) return;
    await _gameStateViewModel.toggleGameState();
    final error = _gameStateViewModel.errorMessage.value;
    if (error.isNotEmpty && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    // Immediately react to the new state on the admin's own device.
    _handleGameStateChange(_gameStateViewModel.gameState.value?.endedAt);
  }

  Future<bool?> _confirmToggle({required bool isCurrentlyEnded}) {
    final title = isCurrentlyEnded ? '게임 재개' : '게임 종료';
    final message = isCurrentlyEnded
        ? '게임을 다시 시작하시겠습니까?'
        : '게임을 종료하고 우승 팀을 공개하시겠습니까?';
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
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
          Obx(() {
            final isEnded =
                _gameStateViewModel.gameState.value?.isEnded ?? false;
            return IconButton(
              icon: Icon(
                isEnded ? Icons.play_arrow : Icons.emoji_events,
              ),
              tooltip: isEnded ? '게임 재개' : '게임 종료',
              onPressed: _onGameEndPressed,
            );
          }),
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

