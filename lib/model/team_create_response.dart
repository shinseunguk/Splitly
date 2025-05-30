class TeamCreateResponse {
  final int teamId;
  final String message;

  TeamCreateResponse({required this.teamId, required this.message});

  factory TeamCreateResponse.fromJson(Map<String, dynamic> json) {
    return TeamCreateResponse(
      teamId: json['teamId'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'teamId': teamId, 'message': message};
}
