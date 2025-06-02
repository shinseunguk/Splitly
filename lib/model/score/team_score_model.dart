class TeamScoreModel {
  final int teamId;
  final String teamName;
  final int teamScore;
  final int? teamRank;
  final String teamLeader;
  final List<String> teamMembers;

  TeamScoreModel({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    required this.teamRank,
    required this.teamLeader,
    required this.teamMembers,
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
    );
  }

  Map<String, dynamic> toJson() => {
    'teamId': teamId,
    'teamName': teamName,
    'teamScore': teamScore,
    'teamRank': teamRank,
    'teamLeader': teamLeader,
    'teamMembers': teamMembers,
  };

  TeamScoreModel copyWith({
    int? teamId,
    String? teamName,
    int? teamScore,
    int? teamRank,
    String? teamLeader,
    List<String>? teamMembers,
  }) {
    return TeamScoreModel(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamScore: teamScore ?? this.teamScore,
      teamRank: teamRank ?? this.teamRank,
      teamLeader: teamLeader ?? this.teamLeader,
      teamMembers: teamMembers ?? this.teamMembers,
    );
  }
}
