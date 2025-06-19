import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:splitly/model/score/team_score_model.dart';

class TeamScoreDataSource {
  Future<List<TeamScoreModel>> fetchTeamScores() async {
    final response = await http.get(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/scores',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => TeamScoreModel.fromJson(e)).toList();
    } else {
      throw Exception('팀 점수 데이터를 불러오지 못했습니다');
    }
  }

  Future<List<TeamScoreModel>> resetTeamScores() async {
    final response = await http.delete(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/scores',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => TeamScoreModel.fromJson(e)).toList();
    } else {
      throw Exception('팀 점수 초기화에 실패했습니다: \n${response.body}');
    }
  }

  Future<List<TeamScoreModel>> updateTeamScore({
    required int teamId,
    required int score,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/scores',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'teamId': teamId, 'score': score}),
    );
    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => TeamScoreModel.fromJson(e)).toList();
    } else {
      throw Exception('팀 점수 업데이트에 실패했습니다: \n${response.body}');
    }
  }

  Future<List<TeamScoreModel>> changeTeamScore({
    required int teamId,
    required int score,
  }) async {
    final response = await http.put(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/scores/$teamId',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'score': score}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => TeamScoreModel.fromJson(e)).toList();
    } else {
      throw Exception('팀 점수 변경에 실패했습니다: \n${response.body}');
    }
  }
}
