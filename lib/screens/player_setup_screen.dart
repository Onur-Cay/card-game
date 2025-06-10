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
    TextEditingController(text: 'Bot 1'),
  ];
  final List<bool> _isBot = [false, true]; // First is player, second is bot

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addBotPlayer() {
    if (_controllers.length < 5) {
      setState(() {
        final botCount = _isBot.where((isBot) => isBot).length;
        _controllers.add(TextEditingController(text: 'Bot ${botCount + 1}'));
        _isBot.add(true);
      });
    }
  }

  void _removeBot() {
    if (_isBot.where((isBot) => isBot).length > 1) {
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

    // Check if player name is empty
    if (playerNames[0].isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
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
                  'Enter Your Name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
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
                                  labelText: 'Your Name',
                                  border: const OutlineInputBorder(),
                                  counterText: '',
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
                      onPressed: _isBot.where((isBot) => isBot).length > 1
                          ? _removeBot
                          : null,
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
