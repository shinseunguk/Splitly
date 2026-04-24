class GameStateModel {
  final bool isEnded;
  final DateTime? endedAt;
  final DateTime? updatedAt;

  GameStateModel({
    required this.isEnded,
    required this.endedAt,
    required this.updatedAt,
  });

  factory GameStateModel.fromJson(Map<String, dynamic> json) {
    return GameStateModel(
      isEnded: json['isEnded'] as bool,
      endedAt:
          json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
