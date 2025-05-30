import 'package:get/get.dart';
import 'package:splitly/model/team_create_response.dart';
import 'package:splitly/model/team_model.dart';
import 'package:splitly/repository/team_repository.dart';

class TeamViewModel extends GetxController {
  final TeamRepository _repository;
  TeamViewModel({TeamRepository? repository})
    : _repository = repository ?? TeamRepository();

  var isLoading = false.obs;
  var creatResponse = Rxn<TeamCreateResponse>();
  var selectResponse = Rxn<List<TeamModel>>();
  var errorMessage = ''.obs;

  Future<void> fetchTeams() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final teams = await _repository.fetchTeams();
      selectResponse.value = teams;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTeam({
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _repository.createTeam(
        teamName: teamName,
        leader: leader,
        members: members,
      );
      creatResponse.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTeam({
    required int teamId,
    required String teamName,
    required String leader,
    required List<String> members,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _repository.updateTeam(
        teamId: teamId,
        teamName: teamName,
        leader: leader,
        members: members,
      );
      creatResponse.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTeam(int teamId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _repository.deleteTeam(teamId);
      // 삭제 후 목록 갱신
      await fetchTeams();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
