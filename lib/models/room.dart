class Room {
  final String id;
  final String name;
  final String hostId;
  final List<String> players;
  final String status;
  final int maxPlayers;
  final String shareableLink;
  final int botCount;

  Room({
    required this.id,
    required this.name,
    required this.hostId,
    required this.players,
    required this.status,
    required this.maxPlayers,
    required this.shareableLink,
    this.botCount = 0,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      hostId: json['host_id'],
      players: List<String>.from(json['players']),
      status: json['status'],
      maxPlayers: json['max_players'],
      shareableLink: json['shareable_link'],
      botCount: json['bot_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host_id': hostId,
      'players': players,
      'status': status,
      'max_players': maxPlayers,
      'shareable_link': shareableLink,
      'bot_count': botCount,
    };
  }
}
