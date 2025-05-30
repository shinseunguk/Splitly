import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitly/viewModel/team_create_view_model.dart';

class TeamCreateView extends StatefulWidget {
  final int? initTeamId;
  final String? initialTeamName;
  final String? initialLeader;
  final List<String>? initialMembers;

  const TeamCreateView({
    super.key,
    this.initTeamId,
    this.initialTeamName,
    this.initialLeader,
    this.initialMembers,
  });

  @override
  State<TeamCreateView> createState() => _TeamCreateViewState();
}

class _TeamCreateViewState extends State<TeamCreateView> {
  final TeamCreateViewModel _viewModel = Get.put(TeamCreateViewModel());
  late final TextEditingController _teamNameController;
  late final TextEditingController _leaderController;
  late final List<TextEditingController> _memberControllers;
  late final bool _isEditMode;
  late final String _titleText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isEditMode = widget.initTeamId != null;
    _titleText = _isEditMode ? '팀 수정' : '팀 생성';
  }

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(
      text: widget.initialTeamName ?? '',
    );
    _leaderController = TextEditingController(text: widget.initialLeader ?? '');
    _memberControllers = List.generate(
      5,
      (i) => TextEditingController(
        text:
            widget.initialMembers != null && i < widget.initialMembers!.length
                ? widget.initialMembers![i]
                : '',
      ),
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _leaderController.dispose();
    for (final c in _memberControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 성공 메시지 감지 후 뒤로가기
    ever(_viewModel.response, (res) {
      if ((res != null && res.message == '팀이 성공적으로 생성되었습니다.') ||
          (res != null && res.message == '팀이 성공적으로 수정되었습니다.')) {
        Navigator.of(context).pop(); // 무조건 한 번만 pop
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(_titleText), backgroundColor: Colors.blue),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_viewModel.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        _viewModel.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const Text("팀명 :"),
                  TextField(controller: _teamNameController),
                  const SizedBox(height: 24),
                  const Text("팀장 :"),
                  TextField(controller: _leaderController),
                  const SizedBox(height: 24),
                  const Text("팀원 (최대 5명):"),
                  ...List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _memberControllers[i],
                        decoration: InputDecoration(hintText: '팀원 ${i + 1}'),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titleText == '팀 생성') {
                            _viewModel.createTeam(
                              teamName: _teamNameController.text,
                              leader: _leaderController.text,
                              members:
                                  _memberControllers
                                      .map((c) => c.text)
                                      .where((name) => name.isNotEmpty)
                                      .toList(),
                            );
                          } else if (_titleText == '팀 수정') {
                            _viewModel.updateTeam(
                              teamId: widget.initTeamId!,
                              teamName: _teamNameController.text,
                              leader: _leaderController.text,
                              members:
                                  _memberControllers
                                      .map((c) => c.text)
                                      .where((name) => name.isNotEmpty)
                                      .toList(),
                            );
                          }
                        },
                        child: Text(_titleText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_viewModel.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}
