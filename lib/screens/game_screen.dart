/// GameScreen
/// ------------
/// This screen represents the main game interface after players are seated.
/// Responsibilities:
/// - Display the central game board (pile, draw deck)
/// - Show each player's cards (currently only the local player's hand)
/// - Manage interactions like drawing and playing cards
/// - Control game progression based on phase (deal, swap, play, end)
///
/// Current implementation includes:
/// - A static hand display for the local player
/// - A placeholder pile area and draw deck with a static card count
/// - Basic UI layout with buttons (Draw, Play, Exit)
///
/// To align with design:
/// - The game should initialize from GameManager and reflect real dealt cards
/// - Player state (faceDown, faceUp, hand) should be used instead of hardcoded asset list
/// - Interactivity (select card, play validation, draw logic) should be implemented
/// - Game state should progress based on player actions and be reactive
import 'package:flutter/material.dart';
import '../game/game_manager.dart';
import '../models/card.dart' as game;
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/draggable_card.dart';
import '../widgets/card_pile.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;

  const GameScreen({Key? key, required this.playerNames}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager _gameManager;
  late GameState _gameState;
  late Player _currentPlayer;

  // CARD SIZE CONFIGURATION
  // These control the base size and scaling of all cards in the game.
  static const double _baseCardWidth = 100.0; // Change this for base card width
  static const double _baseCardHeight = 140.0; // Change this for base card height
  static const double _baseSpacing = 8.0;
  static const double _basePadding = 16.0;

  double _getScaleFactor(BuildContext context) {
    final playerCount = _gameState.players.length;
    
    // Slightly larger scaling percentages based on player count
    switch (playerCount) {
      case 2:
        return 1.0; // 100%
      case 3:
        return 0.8; // 80% (increased from 70%)
      case 4:
        return 0.8; // 60% (increased from 50%)
      case 5:
        return 0.7; // 40% (increased from 30%)
      default:
        return 0.4; // Fallback to smallest size
    }
  }

  double _getDeckScaleFactor(BuildContext context) {
    // Deck is always larger than player cards
    return _getScaleFactor(context) * 1.5;
  }

  double _getScaledCardWidth(BuildContext context) {
    return _baseCardWidth * _getScaleFactor(context);
  }

  double _getScaledCardHeight(BuildContext context) {
    return _baseCardHeight * _getScaleFactor(context);
  }

  double _getScaledDeckWidth(BuildContext context) {
    return _baseCardWidth * _getDeckScaleFactor(context);
  }

  double _getScaledDeckHeight(BuildContext context) {
    return _baseCardHeight * _getDeckScaleFactor(context);
  }

  double _getScaledSpacing(BuildContext context) {
    return _baseSpacing * _getScaleFactor(context);
  }

  double _getScaledPadding(BuildContext context) {
    return _basePadding * _getScaleFactor(context);
  }

  // Helper for hand sorting: Ace > King > ... > 2, Spades > Clubs > Diamonds > Hearts
  int _handSortValue(game.GameCard card) {
    // Map rank to value: Ace=14, King=13, ..., 2=2
    final rankOrder = {
      'A': 14, 'K': 13, 'Q': 12, 'J': 11,
      '10': 10, '9': 9, '8': 8, '7': 7, '6': 6, '5': 5, '4': 4, '3': 3, '2': 2
    };
    // Map suit to value: Spades=0, Clubs=1, Diamonds=2, Hearts=3
    final suitOrder = {
      'spades': 0, 'clubs': 1, 'diamonds': 2, 'hearts': 3
    };
    final rank = rankOrder[card.rank] ?? 0;
    final suit = suitOrder[card.suit] ?? 99;
    // Sort by rank descending, then suit order
    return (100 - rank) * 10 + suit;
  }

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager();
    _gameManager.initializeGame(widget.playerNames);
    _gameState = _gameManager.gameState;
    _currentPlayer = _gameState.currentPlayer;
  }

  void _handleCardSwap(Player player, int faceUpIndex, game.GameCard newCard) {
    setState(() {
      _gameManager.swapFaceUpCard(player, faceUpIndex, newCard);
    });
  }

  void _handleCardPlay(Player player, game.GameCard card) {
    setState(() {
      if (_gameManager.playCard(player, card)) {
        _gameState = _gameManager.gameState;
        _currentPlayer = _gameState.currentPlayer;
      }
    });
  }

  void _handleFaceDownCardPlay(Player player, int index) {
    setState(() {
      if (_gameManager.playFaceDownCard(player, index)) {
        _gameState = _gameManager.gameState;
        _currentPlayer = _gameState.currentPlayer;
      }
    });
  }

  void _handlePickUpDiscardPile(Player player) {
    setState(() {
      _gameManager.pickUpDiscardPile(player);
      _gameState = _gameManager.gameState;
      _currentPlayer = _gameState.currentPlayer;
    });
  }

  void _markPlayerReady(Player player) {
    setState(() {
      _gameManager.markPlayerReady(player);
      _gameState = _gameManager.gameState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = _getScaleFactor(context);
    final cardWidth = _getScaledCardWidth(context);
    final cardHeight = _getScaledCardHeight(context);
    final deckWidth = _getScaledDeckWidth(context);
    final deckHeight = _getScaledDeckHeight(context);
    final spacing = _getScaledSpacing(context);
    final padding = _getScaledPadding(context);
    final playerCount = _gameState.players.length;

    // Calculate expected deck size
    final cardsPerPlayer = 12;
    final totalPlayerCards = playerCount * cardsPerPlayer;
    final expectedDeckSize = 52 - totalPlayerCards;

    return Scaffold(
      appBar: AppBar(
        title: Text('Card Game - ${_gameState.currentPhase.name}'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final opponents = _gameState.players.where((p) => p != _currentPlayer).toList();
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final playerAreaWidth = cardWidth * 5;
            final playerAreaHeight = cardHeight * 1.6;
            final bannerHeight = cardHeight * 2.2;
            final topY = 0.0;
            final leftX = 0.0;
            final rightX = width - playerAreaWidth;
            final centerX = width / 2 - playerAreaWidth / 2;
            final topOffsetY = height * 0.08;
            final topLeftX = width * 0.13;
            final topRightX = width - playerAreaWidth - width * 0.13;

            Widget buildStackedTable() {
              List<Widget> stackChildren = [];
              if (playerCount == 2) {
                // Opponent at top center, facing down
                stackChildren.add(Positioned(
                  top: topY,
                  left: centerX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[0], cardWidth, cardHeight, spacing, rotation: 3.14159),
                  ),
                ));
              } else if (playerCount == 3) {
                // Top-left (opponent 0), angled 45°
                stackChildren.add(Positioned(
                  top: topOffsetY,
                  left: topLeftX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[0], cardWidth, cardHeight, spacing, rotation: 2.35619), // 135°
                  ),
                ));
                // Top-right (opponent 1), angled -45°
                stackChildren.add(Positioned(
                  top: topOffsetY,
                  left: topRightX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[1], cardWidth, cardHeight, spacing, rotation: 3.92699), // 225°
                  ),
                ));
              } else if (playerCount == 4) {
                // Top (opponent 0), facing down
                stackChildren.add(Positioned(
                  top: topY,
                  left: centerX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[0], cardWidth, cardHeight, spacing, rotation: 3.14159),
                  ),
                ));
                // Left (opponent 1), angled 90°
                stackChildren.add(Positioned(
                  top: height / 2 - playerAreaHeight / 2,
                  left: leftX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[1], cardWidth, cardHeight, spacing, rotation: 1.5708),
                  ),
                ));
                // Right (opponent 2), angled 270°
                stackChildren.add(Positioned(
                  top: height / 2 - playerAreaHeight / 2,
                  left: rightX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[2], cardWidth, cardHeight, spacing, rotation: 4.71239),
                  ),
                ));
              } else if (playerCount == 5) {
                // Top-left (opponent 0), angled 135°
                stackChildren.add(Positioned(
                  top: topOffsetY,
                  left: topLeftX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[0], cardWidth, cardHeight, spacing, rotation: 2.35619),
                  ),
                ));
                // Top-right (opponent 1), angled 225°
                stackChildren.add(Positioned(
                  top: topOffsetY,
                  left: topRightX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[1], cardWidth, cardHeight, spacing, rotation: 3.92699),
                  ),
                ));
                // Left (opponent 2), angled 90°
                stackChildren.add(Positioned(
                  top: height / 2 - playerAreaHeight / 2,
                  left: leftX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[2], cardWidth, cardHeight, spacing, rotation: 1.5708),
                  ),
                ));
                // Right (opponent 3), angled 270°
                stackChildren.add(Positioned(
                  top: height / 2 - playerAreaHeight / 2,
                  left: rightX,
                  child: SizedBox(
                    width: playerAreaWidth,
                    height: playerAreaHeight,
                    child: _buildOpponentCards(opponents[3], cardWidth, cardHeight, spacing, rotation: 4.71239),
                  ),
                ));
              }

              // Center deck and current player at the bottom
              stackChildren.add(Positioned(
                top: height / 2 - deckHeight / 2,
                left: width / 2 - deckWidth / 2,
                child: Column(
                  children: [
                    // Center game area (deck)
                    CardPile(
                      cards: _gameState.drawPile,
                      isFaceUp: false,
                      canAcceptCards: false,
                      cardOffset: 0,
                      width: deckWidth,
                      height: deckHeight,
                    ),
                    SizedBox(height: spacing),
                    Text(
                      '${_gameState.drawPile.length}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20 * scaleFactor,
                      ),
                    ),
                    Text(
                      'Expected: $expectedDeckSize',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10 * scaleFactor,
                      ),
                    ),
                  ],
                ),
              ));

              // Ready button above the banner
              if (_gameState.currentPhase == GamePhase.swapping && !_currentPlayer.isReady) {
                stackChildren.add(Positioned(
                  bottom: bannerHeight + 12,
                  left: width / 2 - 60,
                  child: ElevatedButton(
                    onPressed: () => _markPlayerReady(_currentPlayer),
                    child: Text('Ready'),
                  ),
                ));
              }

              // Player's banner at the bottom
              stackChildren.add(Positioned(
                bottom: 0,
                left: width / 2 - playerAreaWidth / 2,
                child: SizedBox(
                  width: playerAreaWidth,
                  height: bannerHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Top row: face-down and face-up cards (centered, not scrollable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: _currentPlayer.faceDownCards.asMap().entries.map((entry) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: spacing),
                                    child: DraggableCard(
                                      card: entry.value,
                                      isFaceUp: false,
                                      isDraggable: _gameState.currentPhase == GamePhase.playing,
                                      onTap: () => _handleFaceDownCardPlay(_currentPlayer, entry.key),
                                      width: cardWidth,
                                      height: cardHeight,
                                    ),
                                  );
                                }).toList(),
                              ),
                              Positioned(
                                top: cardHeight * 0.3,
                                child: Row(
                                  children: _currentPlayer.faceUpCards.asMap().entries.map((entry) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: spacing),
                                      child: DraggableCard(
                                        card: entry.value,
                                        isDraggable: _gameState.currentPhase == GamePhase.swapping,
                                        onTap: () {
                                          if (_gameState.currentPhase == GamePhase.swapping) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Select card to swap'),
                                                content: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: _currentPlayer.hand.map((card) {
                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: spacing),
                                                        child: DraggableCard(
                                                          card: card,
                                                          onTap: () {
                                                            _handleCardSwap(_currentPlayer, entry.key, card);
                                                            Navigator.pop(context);
                                                          },
                                                          width: cardWidth,
                                                          height: cardHeight,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        width: cardWidth,
                                        height: cardHeight,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Bottom row: hand (horizontal scroll, sorted)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        height: cardHeight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (() {
                              final sortedHand = List.from(_currentPlayer.hand)
                                ..sort((a, b) => _handSortValue(a).compareTo(_handSortValue(b)));
                              return sortedHand.map((card) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: spacing),
                                  child: DraggableCard(
                                    card: card,
                                    isDraggable: _gameState.currentPhase == GamePhase.playing,
                                    onTap: () => _handleCardPlay(_currentPlayer, card),
                                    width: cardWidth,
                                    height: cardHeight,
                                  ),
                                );
                              }).toList();
                            })(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
              return Stack(children: stackChildren);
            }

            if (playerCount >= 2 && playerCount <= 5) {
              return buildStackedTable();
            }

            // Fallback to previous layout for other player counts
            return Column(
              children: [
                // Opponents' cards
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (playerCount == 2) {
                        return Center(
                          child: _buildOpponentCards(opponents[0], cardWidth, cardHeight, spacing, rotation: 0.0),
                        );
                      } else if (playerCount == 5) {
                        return Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildOpponentCards(opponents[0], cardWidth, cardHeight, spacing, rotation: 0.523599),
                                  _buildOpponentCards(opponents[1], cardWidth, cardHeight, spacing, rotation: 2.61799),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildOpponentCards(opponents[2], cardWidth, cardHeight, spacing, rotation: 3.66519),
                                  _buildOpponentCards(opponents[3], cardWidth, cardHeight, spacing, rotation: 5.75959),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                // Center deck and current player at the bottom
                Positioned(
                  top: constraints.maxHeight / 2 - cardHeight,
                  left: constraints.maxWidth / 2 - cardWidth / 2,
                  child: Column(
                    children: [
                      // Center game area (deck)
                      CardPile(
                        cards: _gameState.drawPile,
                        isFaceUp: false,
                        canAcceptCards: false,
                        cardOffset: 0,
                        width: deckWidth,
                        height: deckHeight,
                      ),
                      SizedBox(height: spacing),
                      Text(
                        '${_gameState.drawPile.length}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20 * scaleFactor,
                        ),
                      ),
                      Text(
                        'Expected: $expectedDeckSize',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10 * scaleFactor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Current player at the bottom
                Positioned(
                  bottom: 0,
                  left: constraints.maxWidth / 2 - cardWidth * 2,
                  child: Column(
                    children: [
                      // Face-up and face-down cards
                      Container(
                        padding: EdgeInsets.symmetric(vertical: padding / 2),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: _currentPlayer.faceDownCards.asMap().entries.map((entry) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: spacing),
                                        child: DraggableCard(
                                          card: entry.value,
                                          isFaceUp: false,
                                          isDraggable: _gameState.currentPhase == GamePhase.playing,
                                          onTap: () => _handleFaceDownCardPlay(_currentPlayer, entry.key),
                                          width: cardWidth,
                                          height: cardHeight,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Positioned(
                                    top: cardHeight * 0.3,
                                    child: Row(
                                      children: _currentPlayer.faceUpCards.asMap().entries.map((entry) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: spacing),
                                          child: DraggableCard(
                                            card: entry.value,
                                            isDraggable: _gameState.currentPhase == GamePhase.swapping,
                                            onTap: () {
                                              if (_gameState.currentPhase == GamePhase.swapping) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text('Select card to swap'),
                                                    content: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: _currentPlayer.hand.map((card) {
                                                          return Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: spacing),
                                                            child: DraggableCard(
                                                              card: card,
                                                              onTap: () {
                                                                _handleCardSwap(_currentPlayer, entry.key, card);
                                                                Navigator.pop(context);
                                                              },
                                                              width: cardWidth,
                                                              height: cardHeight,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            width: cardWidth,
                                            height: cardHeight,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Hand cards
                      Container(
                        padding: EdgeInsets.symmetric(vertical: padding / 2),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _currentPlayer.hand.map((card) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: spacing),
                                child: DraggableCard(
                                  card: card,
                                  isDraggable: _gameState.currentPhase == GamePhase.playing,
                                  onTap: () => _handleCardPlay(_currentPlayer, card),
                                  width: cardWidth,
                                  height: cardHeight,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (_gameState.currentPhase == GamePhase.swapping && !_currentPlayer.isReady)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: padding / 2),
                          child: ElevatedButton(
                            onPressed: () => _markPlayerReady(_currentPlayer),
                            child: Text('Ready'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOpponentCards(Player player, double cardWidth, double cardHeight, double spacing, {double rotation = 0.0}) {
    return Transform.rotate(
      angle: rotation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              player.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14 * _getScaleFactor(context),
              ),
            ),
            SizedBox(height: spacing),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Row(
                          children: player.faceDownCards.map((card) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                            child: DraggableCard(
                              card: card,
                              isFaceUp: false,
                              isDraggable: false,
                              width: cardWidth,
                              height: cardHeight,
                            ),
                          )).toList(),
                        ),
                        Positioned(
                          top: cardHeight * 0.3,
                          child: Row(
                            children: player.faceUpCards.map((card) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                              child: DraggableCard(
                                card: card,
                                isDraggable: false,
                                width: cardWidth,
                                height: cardHeight,
                              ),
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}