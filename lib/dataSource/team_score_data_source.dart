import 'package:splitly/model/score/team_score_model.dart';

class TeamScoreDataSource {
  Future<List<TeamScoreModel>> fetchTeamScores() async {
    // 실제 API 연동 시에는 http 패키지 등으로 GET 요청을 보내고, 응답을 파싱합니다.
    // 아래는 예시/mock 데이터입니다.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TeamScoreModel(
        teamId: 3,
        teamName: '다크호스',
        teamScore: 27,
        teamRank: 1,
        teamLeader: '이재명',
        teamMembers: ['김유신', '이순신', '신사임당'],
      ),
      TeamScoreModel(
        teamId: 1,
        teamName: '불사조',
        teamScore: 25,
        teamRank: 2,
        teamLeader: '김문수',
        teamMembers: ['홍길동', '김영희', '박철수'],
      ),
      TeamScoreModel(
        teamId: 2,
        teamName: '무적함대',
        teamScore: 19,
        teamRank: 3,
        teamLeader: '이준석',
        teamMembers: ['강감찬', '유관순', '안중근'],
      ),
    ];
  }

  Future<List<TeamScoreModel>> resetTeamScores() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final allTeams = [
      TeamScoreModel(
        teamId: 1,
        teamName: '불사조',
        teamScore: 0,
        teamRank: null,
        teamLeader: '김문수',
        teamMembers: ['홍길동', '김영희', '박철수'],
      ),
      TeamScoreModel(
        teamId: 2,
        teamName: '무적함대',
        teamScore: 0,
        teamRank: null,
        teamLeader: '이준석',
        teamMembers: ['강감찬', '유관순', '안중근'],
      ),
      TeamScoreModel(
        teamId: 3,
        teamName: '다크호스',
        teamScore: 0,
        teamRank: null,
        teamLeader: '이재명',
        teamMembers: ['김유신', '이순신', '신사임당'],
      ),
    ];
    return allTeams;
  }

  Future<List<TeamScoreModel>> updateTeamScore({
    required int teamId,
    required int score,
  }) async {
    print('팀 점수 업데이트 요청: teamId=$teamId, score=$score');

    await Future.delayed(const Duration(milliseconds: 500));
    List<TeamScoreModel> allTeams = [
      TeamScoreModel(
        teamId: 1,
        teamName: '불사조',
        teamScore: 25,
        teamRank: 1,
        teamLeader: '김문수',
        teamMembers: ['홍길동', '김영희', '박철수'],
      ),
      TeamScoreModel(
        teamId: 2,
        teamName: '무적함대',
        teamScore: 19,
        teamRank: 2,
        teamLeader: '이준석',
        teamMembers: ['강감찬', '유관순', '안중근'],
      ),
      TeamScoreModel(
        teamId: 3,
        teamName: '다크호스',
        teamScore: 8,
        teamRank: 3,
        teamLeader: '이재명',
        teamMembers: ['김유신', '이순신', '신사임당'],
      ),
    ];
    return allTeams;
  }

  Future<List<TeamScoreModel>> changeTeamScore({
    required int teamId,
    required int score,
  }) async {
    print('팀 점수 변경 요청: teamId=$teamId, score=$score');

    await Future.delayed(const Duration(milliseconds: 500));
    List<TeamScoreModel> allTeams = [
      TeamScoreModel(
        teamId: 1,
        teamName: '불사조',
        teamScore: 25,
        teamRank: 1,
        teamLeader: '김문수',
        teamMembers: ['홍길동', '김영희', '박철수'],
      ),
      TeamScoreModel(
        teamId: 2,
        teamName: '무적함대',
        teamScore: 19,
        teamRank: 2,
        teamLeader: '이준석',
        teamMembers: ['강감찬', '유관순', '안중근'],
      ),
      TeamScoreModel(
        teamId: 3,
        teamName: '다크호스',
        teamScore: 8,
        teamRank: 3,
        teamLeader: '이재명',
        teamMembers: ['김유신', '이순신', '신사임당'],
      ),
    ];
    return allTeams;
  }
}
