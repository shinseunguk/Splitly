import 'package:splitly/dataSource/team_score_data_source.dart';
import 'package:splitly/model/score/team_score_model.dart';

class TeamScoreRepository {
  final TeamScoreDataSource _dataSource;

  TeamScoreRepository({TeamScoreDataSource? dataSource})
    : _dataSource = dataSource ?? TeamScoreDataSource();

  Future<List<TeamScoreModel>> fetchTeamScores() {
    return _dataSource.fetchTeamScores();
  }

  Future<List<TeamScoreModel>> resetTeamScores() {
    return _dataSource.resetTeamScores();
  }

  Future<List<TeamScoreModel>> updateTeamScore({
    required int teamId,
    required int score,
  }) {
    return _dataSource.updateTeamScore(teamId: teamId, score: score);
  }

  Future<List<TeamScoreModel>> changeTeamScore({
    required int teamId,
    required int score,
  }) {
    return _dataSource.changeTeamScore(teamId: teamId, score: score);
  }
}
