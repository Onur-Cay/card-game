/// PlayingCard
/// -------------
/// This widget is responsible for rendering a single playing card visually.
/// Responsibilities:
/// - Display the card image using the provided asset name (e.g., 'AS.png' or '10H.svg')
/// - Apply visual styling such as rounded corners, gradient background, and border
/// - Provide consistent sizing and layout for card rendering across the app
///
/// To be implemented or considered:
/// - Support for both PNG and SVG sources (if needed)
/// - Optional interactivity such as tap-to-select or drag-and-drop
/// - Visual states (e.g., selected, hovered, disabled)
/// - Flexible sizing or aspect ratio based on screen/device
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayingCard extends StatelessWidget {
  final String assetName; // e.g. 'AS.svg'
  final double width;

  const PlayingCard({
    super.key,
    required this.assetName,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100],
          ),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'cards/large/$assetName', // Use the large PNG asset
            fit: BoxFit.contain,
            height: width * 1.4,
          ),
        ),
      ),
    );
  }
}
