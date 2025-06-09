import 'package:flutter/material.dart';
import 'package:card_game/screens/game_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<bool> _isBot = [false, false]; // Track which players are bots

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    setState(() {
      _controllers.add(TextEditingController());
      _isBot.add(false);
    });
  }

  void _addBotPlayer() {
    setState(() {
      final botCount = _isBot.where((isBot) => isBot).length;
      _controllers.add(TextEditingController(text: 'Bot ${botCount + 1}'));
      _isBot.add(true);
    });
  }

  void _removePlayer() {
    if (_controllers.length > 2) {
      setState(() {
        // Find the last non-bot player
        for (int i = _controllers.length - 1; i >= 0; i--) {
          if (!_isBot[i]) {
            _controllers[i].dispose();
            _controllers.removeAt(i);
            _isBot.removeAt(i);
            break;
          }
        }
      });
    }
  }

  void _removeBot() {
    if (_controllers.length > 2) {
      setState(() {
        // Find the last bot player
        for (int i = _controllers.length - 1; i >= 0; i--) {
          if (_isBot[i]) {
            _controllers[i].dispose();
            _controllers.removeAt(i);
            _isBot.removeAt(i);
            break;
          }
        }
      });
    }
  }

  void _startGame() {
    final playerNames = _controllers
        .map((controller) => controller.text.trim())
        .toList();

    // Check if any player name is empty
    if (playerNames.any((name) => name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter names for all players')),
      );
      return;
    }

    // Check if we have at least 2 players
    if (playerNames.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 2 player names')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(playerNames: playerNames),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Setup'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter Player Names',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300, // Fixed width for text fields
                  child: Column(
                    children: List.generate(_controllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _isBot[index]
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _controllers[index].text,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : TextField(
                                controller: _controllers[index],
                                maxLength: 27,
                                decoration: InputDecoration(
                                  labelText: 'Player ${index + 1}',
                                  border: const OutlineInputBorder(),
                                  counterText: '', // Hide the character counter
                                ),
                                textAlign: TextAlign.center,
                              ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _controllers.length < 5 ? _addPlayer : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Add Player'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _controllers.length < 5 ? _addBotPlayer : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Add Bot'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isBot.where((isBot) => !isBot).length > 1
                          ? _removePlayer
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Remove Player'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isBot.contains(true) ? _removeBot : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Remove Bot'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Start Game'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
