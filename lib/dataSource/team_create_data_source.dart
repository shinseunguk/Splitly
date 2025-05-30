import 'package:get/get.dart';
import 'package:splitly/model/team_create_response.dart';

class TeamCreateDataSource {
  Future<TeamCreateResponse> createTeam({
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    // 실제 API 연동 시에는 http 패키지 등으로 POST 요청을 보내고, 응답을 파싱합니다.
    // 아래는 예시/mock 데이터입니다.
    print('팀 생성 요청:');
    print('팀명: $teamName');
    print('팀장: $leader');
    print('팀원: ${members.join(', ')}');

    await Future.delayed(const Duration(seconds: 1));
    return TeamCreateResponse(teamId: 1, message: '팀이 성공적으로 생성되었습니다.');
  }

  Future<TeamCreateResponse> updateTeam({
    required int teamId,
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    // 실제 API 연동 시에는 http 패키지 등으로 PUT/PATCH 요청을 보내고, 응답을 파싱합니다.
    // 아래는 예시/mock 데이터입니다.
    print('팀 수정 요청:');
    print('팀ID: $teamId');
    print('팀명: $teamName');
    print('팀장: $leader');
    print('팀원: ${members.join(', ')}');

    await Future.delayed(const Duration(seconds: 1));
    return TeamCreateResponse(teamId: teamId, message: '팀이 성공적으로 수정되었습니다.');
  }
}
