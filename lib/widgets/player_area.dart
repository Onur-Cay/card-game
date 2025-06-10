import 'package:flutter/material.dart';
import '../models/card.dart' as game;
import '../models/player.dart';
import '../models/game_state.dart';
import 'card_pile.dart';

class PlayerArea extends StatelessWidget {
  // Base values for dimensions
  static const double baseCardWidth = 90.0;
  static const double baseCardHeight = 100.0;
  static const double baseSpacing = 10.0;
  static const double basePadding = 8.0;
  static const double baseFontSize = 16.0;
  static const double baseSmallFontSize = 14.0;

  final Player player;
  final bool isCurrentPlayer;
  final double scaleFactor;
  final double textRotation;
  final bool textAbove;
  final Function(Player, int)? onFaceDownCardTap;
  final Function(Player, int, game.GameCard)? onFaceUpCardTap;
  final Function(Player, game.GameCard)? onHandCardTap;
  final GameState? gameState;

  const PlayerArea({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    required this.scaleFactor,
    this.textRotation = 0.0,
    this.textAbove = true,
    this.onFaceDownCardTap,
    this.onFaceUpCardTap,
    this.onHandCardTap,
    this.gameState,
  });

  // Computed values
  double get cardWidth => baseCardWidth * scaleFactor;
  double get cardHeight => baseCardHeight * scaleFactor;
  double get spacing => baseSpacing * scaleFactor;
  double get padding => basePadding * scaleFactor;
  double get fontSize => baseFontSize * scaleFactor;
  double get smallFontSize => baseSmallFontSize * scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (textAbove) _buildPlayerInfo(),
        SizedBox(
          height: spacing + cardHeight + (cardHeight * 0.3),
          child: Stack(
            children: [
              // Face-down cards
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  player.faceDownCards.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index < player.faceDownCards.length - 1
                          ? spacing
                          : 0,
                    ),
                    child: GestureDetector(
                      onTap: onFaceDownCardTap != null
                          ? () => onFaceDownCardTap!(player, index)
                          : null,
                      child: CardPile(
                        cards: [player.faceDownCards[index]],
                        width: cardWidth,
                        height: cardHeight,
                        isFaceUp: false,
                        isDraggable: false,
                        gameState: gameState,
                        owner: player,
                      ),
                    ),
                  ),
                ),
              ),
              // Face-up cards (slightly shifted down)
              Positioned(
                top: cardHeight * 0.3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    player.faceUpCards.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        right: index < player.faceUpCards.length - 1
                            ? spacing
                            : 0,
                      ),
                      child: GestureDetector(
                        onTap: onFaceUpCardTap != null
                            ? () => onFaceUpCardTap!(
                                player,
                                index,
                                player.faceUpCards[index],
                              )
                            : null,
                        child: CardPile(
                          cards: [player.faceUpCards[index]],
                          width: cardWidth,
                          height: cardHeight,
                          isFaceUp: true,
                          isDraggable: true,
                          canAcceptCards: true,
                          gameState: gameState,
                          owner: player,
                          onCardDropped: (card) {
                            if (onFaceUpCardTap != null) {
                              onFaceUpCardTap!(player, index, card);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!textAbove) _buildPlayerInfo(),
        // Hand cards (only for current player)
        if (isCurrentPlayer) ...[
          SizedBox(height: spacing),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: player.hand.map((card) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: card != player.hand.last ? spacing : 0,
                  ),
                  child: GestureDetector(
                    onTap: onHandCardTap != null
                        ? () => onHandCardTap!(player, card)
                        : null,
                    child: CardPile(
                      cards: [card],
                      width: cardWidth,
                      height: cardHeight,
                      isFaceUp: true,
                      isDraggable: true,
                      canAcceptCards: false,
                      gameState: gameState,
                      owner: player,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlayerInfo() {
    return Transform.rotate(
      angle: textRotation,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: isCurrentPlayer
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8 * scaleFactor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              player.name,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isCurrentPlayer
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            SizedBox(height: 4 * scaleFactor),
            Text(
              'Cards: ${player.hand.length}',
              style: TextStyle(
                fontSize: smallFontSize,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
