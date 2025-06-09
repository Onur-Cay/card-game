import 'package:flutter/material.dart';
import '../models/card.dart' as game;
import '../models/player.dart';
import 'card_pile.dart';

class PlayerArea extends StatelessWidget {
  final Player player;
  final bool isCurrentPlayer;
  final double cardWidth;
  final double cardHeight;
  final double spacing;
  final double textRotation;
  final bool textOnLeft;
  final Function(Player, int)? onFaceDownCardTap;
  final Function(Player, int, game.GameCard)? onFaceUpCardTap;
  final Function(Player, game.GameCard)? onHandCardTap;

  const PlayerArea({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    required this.cardWidth,
    required this.cardHeight,
    required this.spacing,
    this.textRotation = 0.0,
    this.textOnLeft = false,
    this.onFaceDownCardTap,
    this.onFaceUpCardTap,
    this.onHandCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (textOnLeft) _buildPlayerInfo(),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!textOnLeft) _buildPlayerInfo(),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Face-up cards (slightly shifted down)
                    Positioned(
                      top: cardHeight * 0.3, // Shift down by 30% of card height
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
                                onCardDropped: (card) {
                                  // Handle card dropped on face-up card
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
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerInfo() {
    return Transform.rotate(
      angle: textRotation,
      child: Container(
        padding: EdgeInsets.all(spacing / 2),
        decoration: BoxDecoration(
          color: isCurrentPlayer
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              player.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCurrentPlayer
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            Text(
              'Cards: ${player.hand.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
