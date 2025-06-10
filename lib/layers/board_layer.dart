import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/card_pile.dart';
import 'game_layer.dart';

class BoardLayer extends GameLayer {
  // Base values for dimensions
  static const double baseCardWidth = 90.0;
  static const double baseCardHeight = 100.0;
  static const double baseSpacing = 10.0;
  static const double basePadding = 8.0;

  final GameState gameState;
  final double scaleFactor;
  final double padding;
  final VoidCallback onDrawCard;
  final VoidCallback onReady;

  const BoardLayer({
    required this.gameState,
    required this.scaleFactor,
    required this.padding,
    required this.onDrawCard,
    required this.onReady,
    super.key,
  });

  // Computed values
  double get cardWidth => baseCardWidth * scaleFactor;
  double get cardHeight => baseCardHeight * scaleFactor;
  double get spacing => baseSpacing * scaleFactor;

  @override
  Widget buildLayer(BuildContext context) {
    return Transform.translate(
      offset: const Offset(
        -40,
        -50,
      ), // Move up by 50 logical pixels and slightly right
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Discard pile
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8 * scaleFactor),
              ),
              child: CardPile(
                cards: gameState.discardPile,
                width: cardWidth,
                height: cardHeight,
                isFaceUp: true,
                cardOffset: 0,
                isDraggable: true,
                canAcceptCards: true,
                onCardDropped: (card) {
                  // Handle card dropped on discard pile
                  // You might want to add a callback for this
                },
              ),
            ),
            SizedBox(width: spacing * 2),
            // Draw pile
            GestureDetector(
              onTap: onDrawCard,
              child: CardPile(
                cards: gameState.drawPile,
                width: cardWidth,
                height: cardHeight,
                isFaceUp: false,
                cardOffset: 0,
                isDraggable: true,
                canAcceptCards: false,
              ),
            ),
            // Add extra spacing to prevent player name overlap
            SizedBox(width: cardWidth),
            if (gameState.currentPhase == GamePhase.swapping) ...[
              // Ready button
              ElevatedButton(
                onPressed: onReady,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing * 2,
                    vertical: spacing,
                  ),
                ),
                child: const Text('Ready'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
