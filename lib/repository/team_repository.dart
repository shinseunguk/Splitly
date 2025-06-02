import 'package:splitly/dataSource/team_data_source.dart';
import 'package:splitly/model/team/team_create_response.dart';
import 'package:splitly/model/team/team_model.dart';

class TeamRepository {
  final TeamDataSource _dataSource;

  TeamRepository({TeamDataSource? dataSource})
    : _dataSource = dataSource ?? TeamDataSource();

  Future<List<TeamModel>> fetchTeams() {
    return _dataSource.fetchTeams();
  }

  Future<TeamCreateResponse> createTeam({
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    return _dataSource.createTeam(
      teamName: teamName,
      leader: leader,
      members: members,
    );
  }

  Future<TeamCreateResponse> updateTeam({
    required int teamId,
    required String teamName,
    required String leader,
    required List<String> members,
  }) {
    return _dataSource.updateTeam(
      teamId: teamId,
      teamName: teamName,
      leader: leader,
      members: members,
    );
  }

  Future<void> deleteTeam(int teamId) {
    return _dataSource.deleteTeam(teamId);
  }
}
