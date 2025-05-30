import 'package:get/get.dart';
import 'package:splitly/model/team_create_response.dart';
import 'package:splitly/repository/team_create_repository.dart';

class TeamCreateViewModel extends GetxController {
  final TeamCreateRepository _repository;
  TeamCreateViewModel({TeamCreateRepository? repository})
    : _repository = repository ?? TeamCreateRepository();

  var isLoading = false.obs;
  var response = Rxn<TeamCreateResponse>();
  var errorMessage = ''.obs;

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
      response.value = result;
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
      response.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
