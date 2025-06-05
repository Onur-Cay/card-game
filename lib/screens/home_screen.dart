/// HomeScreen
/// ------------
/// This is the initial screen of the game app that welcomes the player.
/// Responsibilities:
/// - Display the game's title and visual introduction
/// - Provide navigation to the GameScreen to start the match
/// - Offer access to Settings (currently a placeholder)
///
/// To be completed:
/// - Add button to choose number of players
/// - Add button to toggle game rules / how-to-play information
/// - Integrate player name entry or multiplayer setup if needed
///
/// This screen acts as the entry point for all game sessions and configuration.
import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Guys' Game",
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
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement settings
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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