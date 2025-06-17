import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import '../configs/app_config.dart';

class RoomService {
  final String baseUrl;

  RoomService({String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.apiUrl;

  Future<Room> createRoom({
    required String name,
    required String hostId,
    int maxPlayers = 5,
    int botCount = 0,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'host_id': hostId,
        'max_players': maxPlayers,
        'bot_count': botCount,
      }),
    );

    if (response.statusCode == 200) {
      return Room.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create room: ${response.body}');
    }
  }

  Future<List<Room>> getAvailableRooms({String? status}) async {
    final queryParams = status != null ? {'status': status} : null;
    final uri = Uri.parse(
      '$baseUrl/rooms',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> roomsJson = json.decode(response.body);
      return roomsJson.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get rooms: ${response.body}');
    }
  }

  Future<void> joinRoom(String roomId, String playerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms/$roomId/join'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'player_id': playerId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to join room: ${response.body}');
    }
  }

  Future<void> startGame(String roomId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms/$roomId/start'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start game: ${response.body}');
    }
  }
}
