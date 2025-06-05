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

  const CardPile({
    Key? key,
    required this.cards,
    this.isFaceUp = true,
    this.canAcceptCards = false,
    this.onCardDropped,
    this.onCardTapped,
    this.width = 100,
    this.height = 140,
    this.cardOffset = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<game.GameCard>(
      onWillAccept: (card) => canAcceptCards && card != null,
      onAccept: (card) => onCardDropped?.call(card),
      builder: (context, candidateCards, rejectedCards) {
        return Container(
          width: width,
          height: height + (cards.length - 1) * cardOffset,
          child: Stack(
            children: [
              for (var i = 0; i < cards.length; i++)
                Positioned(
                  top: i * cardOffset,
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
                              isFaceUp ? cards[i].assetPath : 'cards/large/card_back.png',
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