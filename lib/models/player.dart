import 'card.dart';

/// Player Model
/// -------------
/// This file defines the Player class used to represent individual game participants.
/// Responsibilities:
/// - Storing the player's unique ID and display name
/// - Managing their hand, face-up, and face-down cards
/// - Tracking whether the player is ready during the swap phase
///
/// This model is used by the GameManager and UI to represent each player's
/// game state throughout the match.

class Player {
  final String id;
  final String name;
  final List<GameCard> hand;
  final List<GameCard> faceUpCards;
  final List<GameCard> faceDownCards;
  bool isReady;

  Player({
    required this.id,
    required this.name,
    List<GameCard>? hand,
    List<GameCard>? faceUpCards,
    List<GameCard>? faceDownCards,
    this.isReady = false,
  })  : hand = hand ?? [],
        faceUpCards = faceUpCards ?? [],
        faceDownCards = faceDownCards ?? [];

  bool get hasPlayableCards => hand.isNotEmpty || faceUpCards.isNotEmpty || faceDownCards.isNotEmpty;

  void addToHand(GameCard card) {
    hand.add(card);
  }

  void removeFromHand(GameCard card) {
    hand.remove(card);
  }

  void swapFaceUpCard(int faceUpIndex, GameCard newCard) {
    if (faceUpIndex >= 0 && faceUpIndex < faceUpCards.length) {
      final oldCard = faceUpCards[faceUpIndex];
      faceUpCards[faceUpIndex] = newCard;
      hand.remove(newCard);
      hand.add(oldCard);
    }
  }

  GameCard? playFaceDownCard(int index) {
    if (index >= 0 && index < faceDownCards.length) {
      return faceDownCards.removeAt(index);
    }
    return null;
  }

  void addToPlayedCards(List<GameCard> cards) {
    hand.addAll(cards);
  }

  @override
  String toString() => name;
}