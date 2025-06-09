import 'package:flutter/material.dart';
import '../models/card.dart' as game;

class DraggableCard extends StatelessWidget {
  final game.GameCard card;
  final bool isFaceUp;
  final bool isDraggable;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const DraggableCard({
    super.key,
    required this.card,
    this.isFaceUp = true,
    this.isDraggable = true,
    this.onTap,
    this.width = 100,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Card(
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
    );

    if (!isDraggable) {
      return cardWidget;
    }

    return Draggable<game.GameCard>(
      data: card,
      feedback: Transform.scale(scale: 1.1, child: cardWidget),
      childWhenDragging: Opacity(opacity: 0.5, child: cardWidget),
      child: GestureDetector(onTap: onTap, child: cardWidget),
    );
  }
}
