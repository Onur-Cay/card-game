import 'package:flutter/material.dart';
import 'package:card_game/screens/player_setup_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize user ID when the home screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).initializeUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade500],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Guys' Card Game",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayerSetupScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Single Player',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Coming Soon'),
                        content: const Text(
                          'Multiplayer mode is currently under development. Please try the single player mode for now!',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Multiplayer',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('How to Play'),
                        content: const SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Basic Rules:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("• In this game suits don't matter"),
                              Text("• This game is for 2-5 players"),
                              Text(
                                '• You can play a card of the same rank (e.g., 6 on 6, Jack on Jack)',
                              ),
                              Text(
                                '• You can play a card of higher rank on a lower rank',
                              ),
                              Text('• Special cards have special effects:'),
                              Text(
                                '  - 7: Can only be played on cards of rank 7 or lower',
                              ),
                              Text('  - 10: Clears the discard pile'),
                              Text('  - 3: Makes the pile invisible/pass'),
                              Text(
                                '  - 2: Makes the pile reset meaning you can play any card on top of it',
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Game Flow:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('• Each player starts with 12 total cards'),
                              Text(
                                '  - 4 on hand that you play until the deck in the middle is empty',
                              ),
                              Text('  - 4 cards face up that everyone can see'),
                              Text(
                                '  - 4 cards face down that no one can see including yourself',
                              ),
                              Text('• On your turn, you:'),
                              Text('  - Play a legal card from your hand'),
                              Text(
                                '  - Then pick up from the deck as long as you have less than 4 cards in your hand',
                              ),
                              Text(
                                '• If you have no legal cards to play, you must pick up the discard pile',
                              ),
                              Text(
                                '• If you have picked up the discard pile, since you have more than 4 cards in your hand you dont have to draw',
                              ),
                              Text(
                                '• Once you finish your hand, then your face up cards and your face down cards you win',
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'How to Play',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement settings
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
