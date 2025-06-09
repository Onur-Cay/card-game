import 'package:flutter/material.dart';

abstract class GameLayer extends StatelessWidget {
  const GameLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return buildLayer(context);
  }

  Widget buildLayer(BuildContext context);
}
