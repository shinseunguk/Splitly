import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GameEndDialog extends StatelessWidget {
  final String teamName;
  final int teamScore;
  final String teamLeader;
  final List<String> teamMembers;
  final ConfettiController confettiController;
  final VoidCallback onClose;

  const GameEndDialog({
    super.key,
    required this.teamName,
    required this.teamScore,
    required this.teamLeader,
    required this.teamMembers,
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
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
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
                  teamName,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '최종 점수: $teamScore점',
                  style: const TextStyle(fontSize: 22, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  '팀장: $teamLeader',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                if (teamMembers.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      '팀원: ${teamMembers.join(', ')}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
