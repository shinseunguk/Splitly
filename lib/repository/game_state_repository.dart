import 'package:splitly/dataSource/game_state_data_source.dart';
import 'package:splitly/model/gameState/game_state_model.dart';

class GameStateRepository {
  final GameStateDataSource _dataSource;

  GameStateRepository({GameStateDataSource? dataSource})
    : _dataSource = dataSource ?? GameStateDataSource();

  Future<GameStateModel> fetchGameState() {
    return _dataSource.fetchGameState();
  }

  Future<GameStateModel> toggleGameState() {
    return _dataSource.toggleGameState();
  }
}
