import 'package:flutter/foundation.dart';
import '../models/room.dart';
import '../services/room_service.dart';
import 'websocket_provider.dart';

class RoomProvider with ChangeNotifier {
  final RoomService _roomService;
  final WebSocketProvider _wsProvider;
  Room? _currentRoom;
  List<Room> _availableRooms = [];
  bool _isLoading = false;
  String? _error;

  RoomProvider({
    RoomService? roomService,
    required WebSocketProvider wsProvider,
  })  : _roomService = roomService ?? RoomService(),
        _wsProvider = wsProvider;

  Room? get currentRoom => _currentRoom;
  List<Room> get availableRooms => _availableRooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createRoom({
    required String name,
    required String hostId,
    int maxPlayers = 5,
    int botCount = 0,
  }) async {
    _setLoading(true);
    try {
      _currentRoom = await _roomService.createRoom(
        name: name,
        hostId: hostId,
        maxPlayers: maxPlayers,
        botCount: botCount,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentRoom = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAvailableRooms({String? status}) async {
    _setLoading(true);
    try {
      _availableRooms = await _roomService.getAvailableRooms(status: status);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _availableRooms = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> joinRoom(String roomId, String playerId) async {
    _setLoading(true);
    try {
      await _roomService.joinRoom(roomId, playerId);
      // After joining, fetch the updated room info
      await fetchAvailableRooms();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startGame(String roomId) async {
    _setLoading(true);
    try {
      await _roomService.startGame(roomId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startSinglePlayerGame({
    required String playerName,
    required String playerId,
    required int botCount,
  }) async {
    _setLoading(true);
    try {
      // 1. Create room
      final room = await _roomService.createRoom(
        name: '$playerName\'s Game',
        hostId: playerId,
        maxPlayers: botCount + 1,
        botCount: botCount,
      );

      // 2. Start game
      await _roomService.startGame(room.id);

      // 3. Initialize WebSocket connection with 'game' screen
      _wsProvider.initializeWebSocket(room.id, playerId);
      _wsProvider.changeScreen('game'); // Make sure we're in game screen

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentRoom() {
    _currentRoom = null;
    notifyListeners();
  }
}
