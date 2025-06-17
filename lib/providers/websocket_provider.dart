import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketService? _webSocketService;
  Map<String, dynamic>? _gameState;
  Map<String, dynamic>? _roomInfo;
  String? _error;

  WebSocketService? get webSocketService => _webSocketService;
  Map<String, dynamic>? get gameState => _gameState;
  Map<String, dynamic>? get roomInfo => _roomInfo;
  String? get error => _error;

  void initializeWebSocket(String roomId, String playerId) {
    _webSocketService = WebSocketService(
      onGameStateUpdate: _handleGameStateUpdate,
      onRoomInfoUpdate: _handleRoomInfoUpdate,
      onPlayerDisconnected: _handlePlayerDisconnected,
      onError: _handleError,
    );

    _webSocketService?.connect(roomId, playerId);
  }

  void _handleGameStateUpdate(Map<String, dynamic> data) {
    _gameState = data['data'];
    notifyListeners();
  }

  void _handleRoomInfoUpdate(Map<String, dynamic> data) {
    _roomInfo = data['data'];
    notifyListeners();
  }

  void _handlePlayerDisconnected(Map<String, dynamic> data) {
    // Handle player disconnection
    notifyListeners();
  }

  void _handleError(String error) {
    _error = error;
    notifyListeners();
  }

  void changeScreen(String screen) {
    _webSocketService?.changeScreen(screen);
  }

  void playCard(Map<String, dynamic> card, {String source = 'hand'}) {
    _webSocketService?.playCard(card, source: source);
  }

  void playFaceDownCard(int cardIndex) {
    _webSocketService?.playFaceDownCard(cardIndex);
  }

  void playerReady({
    required List<Map<String, dynamic>> hand,
    required List<Map<String, dynamic>> faceUp,
  }) {
    _webSocketService?.playerReady(hand: hand, faceUp: faceUp);
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }
}
