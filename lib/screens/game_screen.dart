import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../game/game_manager.dart';
import '../models/card.dart' as game;
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/draggable_card.dart';
import '../widgets/card_pile.dart';
import '../layers/board_layer.dart';
import '../layers/player_layer.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;

  const GameScreen({super.key, required this.playerNames});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager _gameManager;
  late GameState _gameState;
  late Player _currentPlayer;

  // Card dimensions
  final double _cardWidth = 90.0;
  final double _cardHeight = 130.0;
  final double _spacing = 10.0;
  final double _padding = 20.0;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager();
    _gameManager.initializeGame(widget.playerNames);
    _gameState = _gameManager.gameState;
    _currentPlayer = _gameState.currentPlayer;
  }

  void _handleDrawCard() {
    setState(() {
      _gameManager.drawCard(_currentPlayer);
    });
  }

  void _handleReady() {
    setState(() {
      _gameManager.markPlayerReady(_currentPlayer);
    });
  }

  void _handleCardSwap(Player player, int faceUpIndex, game.GameCard newCard) {
    setState(() {
      _gameManager.swapFaceUpCard(player, faceUpIndex, newCard);
    });
  }

  void _handleFaceDownCardPlay(Player player, int index) {
    setState(() {
      _gameManager.playFaceDownCard(player, index);
    });
  }

  void _handleCardPlay(Player player, game.GameCard card) {
    setState(() {
      _gameManager.playCard(player, card);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
                    children: [
          // Back button
                  Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
          // Board layer (draw pile, discard pile, ready button)
          BoardLayer(
            gameState: _gameState,
            onDrawCard: _handleDrawCard,
            onReady: _handleReady,
            cardWidth: _cardWidth,
            cardHeight: _cardHeight,
            spacing: _spacing,
            padding: _padding,
              ),
          // Player layer (all players' cards and positions)
          PlayerLayer(
            gameState: _gameState,
            currentPlayer: _currentPlayer,
            onCardSwap: _handleCardSwap,
            onFaceDownCardPlay: _handleFaceDownCardPlay,
            onCardPlay: _handleCardPlay,
            cardWidth: _cardWidth,
            cardHeight: _cardHeight,
            spacing: _spacing,
            padding: _padding,
            screenSize: MediaQuery.of(context).size,
          ),
        ],
      ),
    );
  }
}
