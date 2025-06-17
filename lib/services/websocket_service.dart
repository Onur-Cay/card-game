import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../configs/app_config.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  String? _playerId;
  String _currentScreen = 'lobby';

  // Callbacks for different message types
  final Function(Map<String, dynamic>)? onGameStateUpdate;
  final Function(Map<String, dynamic>)? onRoomInfoUpdate;
  final Function(Map<String, dynamic>)? onPlayerDisconnected;
  final Function(String)? onError;

  WebSocketService({
    this.onGameStateUpdate,
    this.onRoomInfoUpdate,
    this.onPlayerDisconnected,
    this.onError,
  });

  void connect(String roomId, String playerId) {
    _playerId = playerId;

    final wsUrl = '${AppConfig.wsUrl}/$roomId/$playerId?screen=$_currentScreen';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel?.stream.listen(
      (message) {
        final data = json.decode(message);
        _handleMessage(data);
      },
      onError: (error) {
        onError?.call(error.toString());
      },
      onDone: () {
        // Handle connection closed
        onError?.call('WebSocket connection closed');
      },
    );
  }

  void _handleMessage(Map<String, dynamic> data) {
    final type = data['type'];
    final screen = data['screen'];

    switch (type) {
      case 'game_state':
        onGameStateUpdate?.call(data);
        break;
      case 'room_info':
        onRoomInfoUpdate?.call(data);
        break;
      case 'player_disconnected':
        onPlayerDisconnected?.call(data);
        break;
      case 'error':
        onError?.call(data['error']);
        break;
    }
  }

  void changeScreen(String screen) {
    _currentScreen = screen;
    _sendMessage({'screen': screen});
  }

  void playCard(Map<String, dynamic> card, {String source = 'hand'}) {
    _sendMessage({'action': 'play_card', 'card': card, 'source': source});
  }

  void playFaceDownCard(int cardIndex) {
    _sendMessage({'action': 'play_face_down_card', 'card_index': cardIndex});
  }

  void playerReady({
    required List<Map<String, dynamic>> hand,
    required List<Map<String, dynamic>> faceUp,
  }) {
    _sendMessage({'action': 'player_ready', 'hand': hand, 'face_up': faceUp});
  }

  void _sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(message));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
