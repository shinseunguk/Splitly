import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitly/main.dart' show routeObserver;
import 'package:splitly/view/team_create_view.dart';
import 'package:splitly/model/team/team_model.dart';
import 'package:splitly/viewModel/team_create_view_model.dart';

class TeamManageView extends StatefulWidget {
  const TeamManageView({super.key});

  @override
  State<TeamManageView> createState() => _TeamMangeViewState();
}

class _TeamMangeViewState extends State<TeamManageView> with RouteAware {
  final TeamViewModel _viewModel = Get.put(TeamViewModel());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _viewModel.fetchTeams();
  }

  @override
  void didPopNext() {
    _viewModel.fetchTeams();
  }

  @override
  void initState() {
    super.initState();
    _viewModel.fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 관리'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamCreateView()),
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
        final teams = _viewModel.selectResponse.value ?? [];
        if (teams.isEmpty) {
          return const Center(child: Text('팀이 없습니다.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 1.1,
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return teamContainer(
              team: team,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamCreateView(teamModel: team),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget teamContainer({
    required TeamModel team,
    VoidCallback? onTap,
  }) => GestureDetector(
    onTap: onTap,
    onLongPress: () async {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('팀 삭제'),
              content: Text('정말 "${team.teamName}" 팀을 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('삭제', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
      );
      if (result == true) {
        // TODO: 실제 삭제 로직 연결 필요 (예: _viewModel.deleteTeam(team.teamId))
        _viewModel.deleteTeam(team.teamId);
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue[100 * ((team.teamId % 8) + 1)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              team.teamName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '팀장: ${team.teamLeader}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '팀원: ${team.members.join(', ')}',
              style: const TextStyle(fontSize: 13),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
