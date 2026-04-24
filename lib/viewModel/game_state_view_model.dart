import 'package:get/get.dart';
import 'package:splitly/model/gameState/game_state_model.dart';
import 'package:splitly/repository/game_state_repository.dart';

class GameStateViewModel extends GetxController {
  final GameStateRepository _repository;
  GameStateViewModel({GameStateRepository? repository})
    : _repository = repository ?? GameStateRepository();

  final Rxn<GameStateModel> gameState = Rxn<GameStateModel>();
  final RxString errorMessage = ''.obs;

  Future<void> fetchGameState() async {
    try {
      gameState.value = await _repository.fetchGameState();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> toggleGameState() async {
    try {
      gameState.value = await _repository.toggleGameState();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
