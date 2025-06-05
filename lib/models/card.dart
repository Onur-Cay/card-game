/// GameCard Model
/// ---------------
/// This file defines the GameCard class and card-related enums.
/// Responsibilities:
/// - Representing a single playing card using suit and rank
/// - Providing a string representation and asset filename for rendering
/// - Defining card suits (spades, hearts, diamonds, clubs)
/// - Defining card ranks (ace through king)
///
/// This model is used by the game logic to build decks, deal hands,
/// compare card values, and generate asset paths for UI rendering.

enum Suit { spades, hearts, diamonds, clubs }
enum Rank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class GameCard {
  final Suit suit;
  final Rank rank;
  bool isFaceUp;

  GameCard({
    required this.suit,
    required this.rank,
    this.isFaceUp = true,
  });

  bool get isSpecial => rank == Rank.two || rank == Rank.seven || rank == Rank.ten;

  bool canPlayOn(GameCard other) {
    if (isSpecial) {
      if (rank == Rank.seven) {
        return false; // Special handling for 7 in game logic
      }
      return true; // Other special cards can be played anytime
    }
    
    if (other.rank == Rank.seven) {
      return rank.index < Rank.seven.index;
    }
    
    return rank.index > other.rank.index;
  }

  String get assetPath {
    String rankStr;
    switch (rank) {
      case Rank.ace:
        rankStr = 'A';
        break;
      case Rank.two:
        rankStr = '02';
        break;
      case Rank.three:
        rankStr = '03';
        break;
      case Rank.four:
        rankStr = '04';
        break;
      case Rank.five:
        rankStr = '05';
        break;
      case Rank.six:
        rankStr = '06';
        break;
      case Rank.seven:
        rankStr = '07';
        break;
      case Rank.eight:
        rankStr = '08';
        break;
      case Rank.nine:
        rankStr = '09';
        break;
      case Rank.ten:
        rankStr = '10';
        break;
      case Rank.jack:
        rankStr = 'J';
        break;
      case Rank.queen:
        rankStr = 'Q';
        break;
      case Rank.king:
        rankStr = 'K';
        break;
    }
    return 'cards/large/card_${suit.name}_$rankStr.png';
  }

  @override
  String toString() => '${rank.name} of ${suit.name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameCard &&
          runtimeType == other.runtimeType &&
          suit == other.suit &&
          rank == other.rank;

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode;
}