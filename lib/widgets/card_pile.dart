import 'package:flutter/material.dart';
import '../models/card.dart' as game;
import '../models/game_state.dart';
import '../models/player.dart';

class CardPile extends StatelessWidget {
  final List<game.GameCard> cards;
  final double width;
  final double height;
  final bool isFaceUp;
  final bool isDraggable;
  final bool canAcceptCards;
  final Function(game.GameCard)? onCardDropped;
  final GameState? gameState;
  final Player? owner;
  final double cardOffset;

  const CardPile({
    super.key,
    required this.cards,
    required this.width,
    required this.height,
    required this.isFaceUp,
    this.isDraggable = false,
    this.canAcceptCards = false,
    this.onCardDropped,
    this.gameState,
    this.owner,
    this.cardOffset = 0.0,
  });

  bool get _canDrag {
    if (!isDraggable) return false;
    if (gameState == null) return true;
    
    // Don't allow dragging during swapping phase
    if (gameState!.currentPhase == GamePhase.swapping) return false;
    
    // Only allow dragging if it's the owner's turn
    if (owner != null && gameState!.currentPlayer != owner) return false;
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return SizedBox(width: width, height: height);
    }

    final card = cards.first;
    return Draggable<game.GameCard>(
      data: _canDrag ? card : null,
      feedback: Transform.scale(
        scale: 1.1,
        child: Card(
          elevation: 4,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(
                  isFaceUp ? card.assetPath : 'cards/large/card_back.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Card(
          elevation: 4,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(
                  isFaceUp ? card.assetPath : 'cards/large/card_back.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      child: Card(
        elevation: 4,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(
                isFaceUp ? card.assetPath : 'cards/large/card_back.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
