import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/card_pile.dart';
import 'game_layer.dart';

class BoardLayer extends GameLayer {
  final GameState gameState;
  final double cardWidth;
  final double cardHeight;
  final double spacing;
  final double padding;
  final VoidCallback onDrawCard;
  final VoidCallback onReady;

  const BoardLayer({
    required this.gameState,
    required this.cardWidth,
    required this.cardHeight,
    required this.spacing,
    required this.padding,
    required this.onDrawCard,
    required this.onReady,
    super.key,
  });

  @override
  Widget buildLayer(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -50), // Move up by 50 logical pixels
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            SizedBox(width: spacing * 2),
            // Discard pile
            CardPile(
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
            if (gameState.currentPhase == GamePhase.swapping) ...[
              SizedBox(width: spacing * 2),
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
