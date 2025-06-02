import 'package:get/get.dart';
import 'package:splitly/model/score/team_score_model.dart';
import 'package:splitly/repository/team_score_repository.dart';

class TeamScoreViewModel extends GetxController {
  final TeamScoreRepository _repository;
  TeamScoreViewModel({TeamScoreRepository? repository})
    : _repository = repository ?? TeamScoreRepository();

  var isLoading = false.obs;
  var teamScores = Rxn<List<TeamScoreModel>>();
  var errorMessage = ''.obs;

  Future<void> fetchTeamScores() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final scores = await _repository.fetchTeamScores();
      teamScores.value = scores;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetTeamScores() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final newList = await _repository.resetTeamScores();
      print("점수 초기화 완료: $newList");
      teamScores.value = newList;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTeamScore(int teamId, int score) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final newList = await _repository.updateTeamScore(
        teamId: teamId,
        score: score,
      );
      teamScores.value = newList;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeTeamScore(int teamId, int score) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final newList = await _repository.changeTeamScore(
        teamId: teamId,
        score: score,
      );
      teamScores.value = newList;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
