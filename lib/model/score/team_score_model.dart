class TeamScoreModel {
  final int teamId;
  final String teamName;
  final int teamScore;
  final int? teamRank;
  final String teamLeader;
  final List<String> teamMembers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeamScoreModel({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    required this.teamRank,
    required this.teamLeader,
    required this.teamMembers,
    this.createdAt,
    this.updatedAt,
  });

  factory TeamScoreModel.fromJson(Map<String, dynamic> json) {
    return TeamScoreModel(
      teamId: json['teamId'] as int,
      teamName: json['teamName'] as String,
      teamScore: json['teamScore'] as int,
      teamRank: json['teamRank'] == null ? null : json['teamRank'] as int,
      teamLeader: json['teamLeader'] as String,
      teamMembers:
          (json['teamMembers'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'teamId': teamId,
    'teamName': teamName,
    'teamScore': teamScore,
    'teamRank': teamRank,
    'teamLeader': teamLeader,
    'teamMembers': teamMembers,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  TeamScoreModel copyWith({
    int? teamId,
    String? teamName,
    int? teamScore,
    int? teamRank,
    String? teamLeader,
    List<String>? teamMembers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeamScoreModel(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamScore: teamScore ?? this.teamScore,
      teamRank: teamRank ?? this.teamRank,
      teamLeader: teamLeader ?? this.teamLeader,
      teamMembers: teamMembers ?? this.teamMembers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
