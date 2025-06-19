import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splitly/model/team/team_create_response.dart';
import 'package:splitly/model/team/team_model.dart';

class TeamDataSource {
  Future<List<TeamModel>> fetchTeams() async {
    final response = await http.get(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/scores/',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => TeamModel.fromJson(e)).toList();
    } else {
      throw Exception('팀 데이터를 불러오지 못했습니다');
    }
  }

  Future<TeamCreateResponse> createTeam({
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    print('팀 생성 요청:');
    print('팀명: $teamName');
    print('팀장: $leader');
    print('팀원: ${members.join(', ')}');
    final response = await http.post(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/teams',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'teamName': teamName,
        'teamLeader': leader,
        'teamMembers': members,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return TeamCreateResponse.fromJson(data);
    } else {
      throw Exception('팀 생성에 실패했습니다: \\n${response.body}');
    }
  }

  Future<TeamCreateResponse> updateTeam({
    required int teamId,
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    final response = await http.put(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/teams/$teamId',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'teamId': teamId.toString(),
        'teamName': teamName,
        'teamLeader': leader,
        'teamMembers': members,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return TeamCreateResponse.fromJson(data);
    } else {
      throw Exception('팀 수정에 실패했습니다: \n${response.body}');
    }
  }

  Future<void> deleteTeam(int teamId) async {
    final response = await http.delete(
      Uri.parse(
        'https://incross-workshop-337441565570.asia-northeast3.run.app/api/v1/admin/teams/$teamId',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('팀 삭제에 실패했습니다: \n${response.body}');
    }
  }
}
