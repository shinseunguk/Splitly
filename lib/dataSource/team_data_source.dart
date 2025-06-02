import 'package:get/get.dart';
import 'package:splitly/model/team/team_create_response.dart';
import 'package:splitly/model/team/team_model.dart';

class TeamDataSource {
  Future<List<TeamModel>> fetchTeams() async {
    // 실제 API 연동 시에는 http 패키지 등으로 GET 요청을 보내고, 응답을 파싱합니다.
    // 아래는 예시/mock 데이터입니다.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TeamModel(
        teamId: 1,
        teamName: '불사조',
        teamScore: 15,
        teamRank: 3,
        teamLeader: '신승욱',
        teamMembers: ['홍길동', '김영희'],
      ),
      TeamModel(
        teamId: 2,
        teamName: '드래곤',
        teamScore: 23,
        teamRank: 2,
        teamLeader: '이철수',
        teamMembers: ['박민수', '최지우', '한가영'],
      ),
      TeamModel(
        teamId: 3,
        teamName: '다크호스',
        teamScore: 27,
        teamRank: 1,
        teamLeader: '이재명',
        teamMembers: ['김유신', '이순신', '신사임당'],
      ),
      TeamModel(
        teamId: 4,
        teamName: '울트라',
        teamScore: 10,
        teamRank: 4,
        teamLeader: '박지성',
        teamMembers: ['손흥민', '이강인'],
      ),
      TeamModel(
        teamId: 5,
        teamName: '썬더',
        teamScore: 8,
        teamRank: 5,
        teamLeader: '최민호',
        teamMembers: ['정우성', '이정재', '김수현'],
      ),
    ];
  }

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

  Future<void> deleteTeam(int teamId) async {
    // 실제 API 연동 시에는 http DELETE 요청을 보내고, 응답을 파싱합니다.
    // 아래는 예시/mock 동작입니다.
    print('팀 삭제 요청: teamId=$teamId');
    await Future.delayed(const Duration(milliseconds: 500));
    // 실제로는 성공/실패 응답을 반환할 수 있음
  }
}
