import 'package:flutter/material.dart';
import '../models/card.dart' as game;

class CardPile extends StatelessWidget {
  final List<game.GameCard> cards;
  final bool isFaceUp;
  final bool canAcceptCards;
  final Function(game.GameCard)? onCardDropped;
  final Function(int)? onCardTapped;
  final double width;
  final double height;
  final double cardOffset;
  final bool isDraggable;

  const CardPile({
    super.key,
    required this.cards,
    this.isFaceUp = true,
    this.canAcceptCards = false,
    this.onCardDropped,
    this.onCardTapped,
    this.width = 100,
    this.height = 140,
    this.cardOffset = 20,
    this.isDraggable = false,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<game.GameCard>(
      onWillAcceptWithDetails: (card) => canAcceptCards && card != null,
      onAcceptWithDetails: (card) => onCardDropped?.call(card.data),
      builder: (context, candidateCards, rejectedCards) {
        return SizedBox(
          width: width,
          height: height + (cards.length - 1) * cardOffset,
          child: Stack(
            children: [
              for (var i = 0; i < cards.length; i++)
                Positioned(
                  top: i * cardOffset,
                  child: isDraggable
                      ? Draggable<game.GameCard>(
                          data: cards[i],
                          feedback: Material(
                            elevation: 8,
                            child: Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(
                                    isFaceUp
                                        ? cards[i].assetPath
                                        : 'cards/large/card_back.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => onCardTapped?.call(i),
                            child: Card(
                              elevation: 4,
                              child: Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      isFaceUp
                                          ? cards[i].assetPath
                                          : 'cards/large/card_back.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => onCardTapped?.call(i),
                          child: Card(
                            elevation: 4,
                            child: Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(
                                    isFaceUp
                                        ? cards[i].assetPath
                                        : 'cards/large/card_back.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
