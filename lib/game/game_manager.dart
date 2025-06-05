import 'dart:math';
import '../models/card.dart';
import '../models/player.dart';
import '../models/game_state.dart';

/// GameManager
/// ------------
/// This class is responsible for managing the core game logic and flow.
/// It handles:
/// - Deck generation and shuffling
/// - Dealing cards to players (hand, face-up, face-down)
/// - Managing the draw pile and played pile
/// - Progressing the game through phases (dealing, swap, playing, ended)
/// - Enforcing game rules and turn logic
/// - Tracking player states and interactions
///
/// This file acts as the single source of truth for all game-side logic,
/// separate from UI code.

class GameManager {
  late GameState _gameState;
  final Random _random = Random();

  GameManager();

  void initializeGame(List<String> playerNames) {
    if (playerNames.length < 2 || playerNames.length > 5) {
      throw Exception('Game requires 2-5 players');
    }

    // Create players
    final players = playerNames
        .asMap()
        .map((index, name) => MapEntry(
            index,
            Player(
              id: 'player_$index',
              name: name,
            )))
        .values
        .toList();

    // Create and shuffle deck(s)
    final decks = List.generate(
        (playerNames.length / 2).ceil(), (_) => _createDeck()).expand((x) => x);
    final drawPile = decks.toList()..shuffle(_random);

    _gameState = GameState(
      players: players,
      drawPile: drawPile,
    );

    _dealInitialCards();
  }

  List<GameCard> _createDeck() {
    final deck = <GameCard>[];
    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        deck.add(GameCard(suit: suit, rank: rank));
      }
    }
    return deck;
  }

  void _dealInitialCards() {
    for (final player in _gameState.players) {
      // Deal 4 face-down cards
      for (var i = 0; i < 4; i++) {
        if (_gameState.drawPile.isNotEmpty) {
          final card = _gameState.drawPile.removeLast();
          card.isFaceUp = false;
          player.faceDownCards.add(card);
        }
      }

      // Deal 4 face-up cards
      for (var i = 0; i < 4; i++) {
        if (_gameState.drawPile.isNotEmpty) {
          player.faceUpCards.add(_gameState.drawPile.removeLast());
        }
      }

      // Deal 4 hand cards
      for (var i = 0; i < 4; i++) {
        if (_gameState.drawPile.isNotEmpty) {
          player.addToHand(_gameState.drawPile.removeLast());
        }
      }
    }

    _gameState.currentPhase = GamePhase.swapping;
  }

  void swapFaceUpCard(Player player, int faceUpIndex, GameCard newCard) {
    if (_gameState.currentPhase != GamePhase.swapping) {
      throw Exception('Can only swap cards during the swapping phase');
    }

    player.swapFaceUpCard(faceUpIndex, newCard);
  }

  void markPlayerReady(Player player) {
    player.isReady = true;
    _checkAllPlayersReady();
  }

  void _checkAllPlayersReady() {
    if (_gameState.players.every((p) => p.isReady)) {
      _gameState.currentPhase = GamePhase.playing;
      _startFirstTurn();
    }
  }

  void _startFirstTurn() {
    if (_gameState.drawPile.isNotEmpty) {
      _gameState.topCard = _gameState.drawPile.removeLast();
      _gameState.addToDiscardPile(_gameState.topCard!);
    }
  }

  bool playCard(Player player, GameCard card) {
    if (_gameState.currentPhase != GamePhase.playing) {
      return false;
    }

    if (player != _gameState.currentPlayer) {
      return false;
    }

    if (_gameState.topCard == null) {
      return false;
    }

    if (!card.canPlayOn(_gameState.topCard!)) {
      return false;
    }

    // Remove card from player's hand
    player.removeFromHand(card);

    // Add card to discard pile
    _gameState.addToDiscardPile(card);

    // Handle special cards
    if (card.rank == Rank.two) {
      _gameState.resetDiscardPile();
    } else if (card.rank == Rank.ten) {
      _gameState.clearDiscardPile();
    }

    // Draw a card if player has less than 4 cards and there are cards in the draw pile
    if (player.hand.length < 4 && _gameState.drawPile.isNotEmpty) {
      player.addToHand(_gameState.drawPile.removeLast());
    }

    // Check for winner
    if (_gameState.checkForWinner()) {
      return true;
    }

    // Move to next player
    _gameState.nextTurn();
    return true;
  }

  bool playFaceDownCard(Player player, int index) {
    if (_gameState.currentPhase != GamePhase.playing) {
      return false;
    }

    if (player != _gameState.currentPlayer) {
      return false;
    }

    final card = player.playFaceDownCard(index);
    if (card == null) {
      return false;
    }

    card.isFaceUp = true;
    return playCard(player, card);
  }

  void pickUpDiscardPile(Player player) {
    if (_gameState.currentPhase != GamePhase.playing) {
      return;
    }

    if (player != _gameState.currentPlayer) {
      return;
    }

    player.addToPlayedCards(_gameState.discardPile);
    _gameState.clearDiscardPile();
    _gameState.nextTurn();
  }

  GameState get gameState => _gameState;
}