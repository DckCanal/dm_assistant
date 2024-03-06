import 'package:dm_assistant/character.dart';
import 'package:dm_assistant/dice.dart';
import 'package:flutter/material.dart';

class Campaign {
  // Game data
  List<Character> characters;
  List<SavedRoll> savedRolls;
  List<RollHistoryEntry> rollHistory;
  String title;

  // Settings
  Color color;
  bool showDisabledChar = false;
  bool inCombat;
  int currentTurn;

  Campaign(
      {required this.title,
      required this.characters,
      required this.savedRolls,
      required this.rollHistory,
      this.color = const Color.fromARGB(255, 13, 0, 133),
      this.showDisabledChar = false,
      this.inCombat = false,
      this.currentTurn = 0});
}
