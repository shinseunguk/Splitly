import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:splitly/model/gameState/game_state_model.dart';

class GameStateDataSource {
  static const String _baseUrl =
      'http://34.22.91.73:3000/api/v1/admin/game-state';

  Future<GameStateModel> fetchGameState() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return GameStateModel.fromJson(data);
    }
    throw Exception('게임 상태를 불러오지 못했습니다: \n${response.body}');
  }

  Future<GameStateModel> toggleGameState() async {
    final response = await http.put(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return GameStateModel.fromJson(data);
    }
    throw Exception('게임 상태 변경에 실패했습니다: \n${response.body}');
  }
}
