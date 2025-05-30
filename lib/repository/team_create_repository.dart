import 'package:splitly/dataSource/team_create_data_source.dart';
import 'package:splitly/model/team_create_response.dart';

class TeamCreateRepository {
  final TeamCreateDataSource _dataSource;

  TeamCreateRepository({TeamCreateDataSource? dataSource})
    : _dataSource = dataSource ?? TeamCreateDataSource();

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
}
