import 'card.dart';
import 'player.dart';

/// GameState Model
/// ----------------
/// This file defines the structure and enums for representing the overall state of the game.
/// Responsibilities:
/// - Tracking the current phase of the game (e.g. dealing, swapping, playing, ended)
/// - Holding references to players, draw pile, discard pile, and turn order
/// - Centralizing all shared state to be accessed by UI and game logic
///
/// This model acts as the bridge between the UI and the core game manager, providing
/// observable game-wide data.

enum GamePhase {
  dealing,
  swapping,
  playing,
  ended
}

class GameState {
  final List<Player> players;
  final List<GameCard> drawPile;
  final List<GameCard> discardPile;
  GamePhase currentPhase;
  int currentPlayerIndex;
  GameCard? topCard;
  Player? winner;

  GameState({
    required this.players,
    required this.drawPile,
    List<GameCard>? discardPile,
    this.currentPhase = GamePhase.dealing,
    this.currentPlayerIndex = 0,
    this.topCard,
    this.winner,
  }) : discardPile = discardPile ?? [];

  Player get currentPlayer => players[currentPlayerIndex];

  bool get isGameOver => currentPhase == GamePhase.ended;

  void nextTurn() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  void addToDiscardPile(GameCard card) {
    discardPile.add(card);
    topCard = card;
  }

  void clearDiscardPile() {
    discardPile.clear();
    topCard = null;
  }

  void resetDiscardPile() {
    if (discardPile.isNotEmpty) {
      drawPile.addAll(discardPile);
      discardPile.clear();
      topCard = null;
    }
  }

  bool checkForWinner() {
    for (final player in players) {
      if (!player.hasPlayableCards) {
        winner = player;
        currentPhase = GamePhase.ended;
        return true;
      }
    }
    return false;
  }
}