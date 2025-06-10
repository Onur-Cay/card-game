import 'package:flutter/material.dart';
import '../models/card.dart' as game;
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/player_area.dart';
import 'dart:math' as math;

abstract class GameLayer extends StatelessWidget {
  const GameLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return buildLayer(context);
  }

  Widget buildLayer(BuildContext context);
}

class SeatLayout {
  final Alignment alignment;
  final double rotation;
  final Offset offset;
  final bool isDeckArea;
  final double deckSpacing;
  final double textRotation; // Rotation for player name and card count
  final bool textAbove; // Whether text should be above the cards

  const SeatLayout({
    required this.alignment,
    required this.rotation,
    this.offset = Offset.zero,
    this.isDeckArea = false,
    this.deckSpacing = 0.0,
    this.textRotation = 0.0,
    this.textAbove = true,
  });
}

class PlayerLayer extends GameLayer {
  final GameState gameState;
  final Player currentPlayer;
  final Function(Player, int, game.GameCard) onCardSwap;
  final Function(Player, int) onFaceDownCardPlay;
  final Function(Player, game.GameCard) onCardPlay;
  final double scaleFactor;
  final double padding;
  final Size screenSize;

  const PlayerLayer({
    super.key,
    required this.gameState,
    required this.currentPlayer,
    required this.onCardSwap,
    required this.onFaceDownCardPlay,
    required this.onCardPlay,
    required this.scaleFactor,
    required this.padding,
    required this.screenSize,
  });

  double _getCardScaleFactor() {
    final playerCount = gameState.players.length;
    switch (playerCount) {
      case 2:
        return 1.0; // Full size for 2 players
      case 3:
        return 1.0; // 90% size for 3 players
      case 4:
        return 1.0; // 80% size for 4 players
      case 5:
        return 0.8; // 70% size for 5 players
      default:
        return 1.0;
    }
  }

  @override
  Widget buildLayer(BuildContext context) {
    final playerScaleFactor = _getCardScaleFactor() * scaleFactor;

    final layouts = _getSeatLayouts();
    return Stack(
      children: [
        // Current player (always at bottom)
        Positioned(
          left: padding,
          right: padding,
          bottom: padding,
          child: PlayerArea(
            player: currentPlayer,
            isCurrentPlayer: true,
            scaleFactor: playerScaleFactor,
            onFaceDownCardTap: onFaceDownCardPlay,
            onFaceUpCardTap: onCardSwap,
            onHandCardTap: onCardPlay,
          ),
        ),
        // Opponent players
        ..._buildOpponentPositions(context, layouts, playerScaleFactor),
      ],
    );
  }

  List<SeatLayout> _getSeatLayouts() {
    final playerCount = gameState.players.length;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate offsets based on screen size
    final topOffset = screenHeight * 0.1; // 10% from top
    final sideOffset = screenWidth * 0.1; // 10% from sides

    switch (playerCount) {
      case 2:
        return [
          SeatLayout(alignment: Alignment.bottomCenter, rotation: 0), // Self
          SeatLayout(
            alignment: Alignment.topCenter,
            rotation: math.pi,
            textRotation: math.pi,
            textAbove: true,
            offset: Offset(0, 0),
          ), // Opponent
        ];
      case 3:
        return [
          SeatLayout(alignment: Alignment.bottomCenter, rotation: 0),
          SeatLayout(
            alignment: Alignment.topLeft,
            rotation: -(math.pi / 180) * 45,
            textRotation: 0,
            textAbove: true,
            offset: Offset(-screenWidth * 0.04, screenHeight * 0.15),
          ),
          SeatLayout(
            alignment: Alignment.topRight,
            rotation: (math.pi / 180) * 45,
            textRotation: 0,
            textAbove: true,
            offset: Offset(screenWidth * 0.04, screenHeight * 0.15),
          ),
        ];
      case 4:
        return [
          SeatLayout(alignment: Alignment.bottomCenter, rotation: 0),
          SeatLayout(
            alignment: Alignment.topCenter,
            rotation: math.pi,
            textRotation: math.pi,
            textAbove: true,
            offset: Offset(0, 0),
          ),
          SeatLayout(
            alignment: Alignment.centerLeft,
            rotation: (math.pi / 180) * 90,
            textRotation: -(math.pi / 180) * 90,
            textAbove: true,
            offset: Offset(-screenWidth * 0.1, 0),
          ),
          SeatLayout(
            alignment: Alignment.centerRight,
            rotation: -(math.pi / 180) * 90,
            textRotation: (math.pi / 180) * 90,
            textAbove: true,
            offset: Offset(screenWidth * 0.1, 0),
          ),
        ];
      case 5:
        return [
          SeatLayout(alignment: Alignment.bottomCenter, rotation: 0),
          SeatLayout(
            alignment: Alignment.topLeft,
            rotation: -(math.pi / 180) * 180,
            textRotation: (math.pi / 180) * 180,
            textAbove: true,
            offset: Offset(screenWidth * 0.1, 0),
          ),
          SeatLayout(
            alignment: Alignment.topRight,
            rotation: (math.pi / 180) * 180,
            textRotation: (math.pi / 180) * 180,
            textAbove: true,
            offset: Offset(-screenWidth * 0.1, 0),
          ),
          SeatLayout(
            alignment: Alignment.centerLeft,
            rotation: -(math.pi / 180) * 90,
            textRotation: (math.pi / 180) * 90,
            textAbove: false,
            offset: Offset(-screenHeight * 0.1, topOffset),
          ),
          SeatLayout(
            alignment: Alignment.centerRight,
            rotation: (math.pi / 180) * 90,
            textRotation: -(math.pi / 180) * 90,
            textAbove: false,
            offset: Offset(screenHeight * 0.1, topOffset),
          ),
        ];
      default:
        return [];
    }
  }

  List<Widget> _buildOpponentPositions(
    BuildContext context,
    List<SeatLayout> layouts,
    double playerScaleFactor,
  ) {
    final opponents = gameState.players
        .where((p) => p != currentPlayer)
        .toList();
    final positions = <Widget>[];

    for (var i = 0; i < opponents.length; i++) {
      final layout =
          layouts[i + 1]; // +1 because first layout is for current player
      positions.add(
        Positioned.fill(
          child: Align(
            alignment: layout.alignment,
            child: Transform.translate(
              offset: layout.offset,
              child: Transform.rotate(
                angle: layout.rotation,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: PlayerArea(
                    player: opponents[i],
                    isCurrentPlayer: false,
                    scaleFactor: playerScaleFactor,
                    textRotation: layout.textRotation,
                    textAbove: layout.textAbove,
                    onFaceDownCardTap: onFaceDownCardPlay,
                    onFaceUpCardTap: onCardSwap,
                    onHandCardTap: onCardPlay,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return positions;
  }
}
