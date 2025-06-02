class TeamModel {
  final int teamId;
  final String teamName;
  final String teamLeader;
  final List<String> members;

  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamLeader,
    required this.members,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['teamId'] as int,
      teamName: json['teamName'] as String,
      teamLeader: json['teamLeader'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'teamId': teamId,
    'teamName': teamName,
    'teamLeader': teamLeader,
    'members': members,
  };
}
