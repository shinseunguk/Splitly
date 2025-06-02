class TeamModel {
  final int teamId;
  final String teamName;
  final int teamScore;
  final int teamRank;
  final String teamLeader;
  final List<String> teamMembers;

  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    required this.teamRank,
    required this.teamLeader,
    required this.teamMembers,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['teamId'] as int,
      teamName: json['teamName'] as String,
      teamScore: json['teamScore'] as int,
      teamRank: json['teamRank'] as int,
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
}
