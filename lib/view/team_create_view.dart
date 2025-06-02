import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitly/model/team/team_model.dart';
import 'package:splitly/viewModel/team_create_view_model.dart';

class TeamCreateView extends StatefulWidget {
  final TeamModel? teamModel;

  const TeamCreateView({super.key, this.teamModel});

  @override
  State<TeamCreateView> createState() => _TeamCreateViewState();
}

class _TeamCreateViewState extends State<TeamCreateView> {
  final TeamViewModel _viewModel = Get.put(TeamViewModel());
  late final TextEditingController _teamNameController;
  late final TextEditingController _leaderController;
  late final List<TextEditingController> _memberControllers;
  late final bool _isEditMode;
  late final String _titleText;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.teamModel != null;
    _titleText = _isEditMode ? '팀 수정' : '팀 생성';
    _teamNameController = TextEditingController(
      text: widget.teamModel?.teamName ?? '',
    );
    _leaderController = TextEditingController(
      text: widget.teamModel?.teamLeader ?? '',
    );
    final members = widget.teamModel?.teamMembers ?? [];
    _memberControllers = List.generate(
      5,
      (i) => TextEditingController(text: i < members.length ? members[i] : ''),
    );
    // 성공 메시지 감지 후 뒤로가기 (build가 아닌 initState에서 등록!)
    ever(_viewModel.creatResponse, (res) {
      if (!mounted) return;
      if ((res != null && res.message == '팀이 성공적으로 생성되었습니다.') ||
          (res != null && res.message == '팀이 성공적으로 수정되었습니다.')) {
        Navigator.of(context).pop();
      }
    });
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
                          final members =
                              _memberControllers
                                  .map((c) => c.text)
                                  .where((name) => name.isNotEmpty)
                                  .toList();
                          if (!_isEditMode) {
                            _viewModel.createTeam(
                              teamName: _teamNameController.text,
                              leader: _leaderController.text,
                              members: members,
                            );
                          } else if (_isEditMode && widget.teamModel != null) {
                            _viewModel.updateTeam(
                              teamId: widget.teamModel!.teamId,
                              teamName: _teamNameController.text,
                              leader: _leaderController.text,
                              members: members,
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
