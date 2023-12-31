import 'package:dm_assistant/character.dart';
import 'package:dm_assistant/dice.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart'; // Assicurati di importare la libreria Color se non è già presente

part 'hive_campaign.g.dart'; // File generato da Hive

@HiveType(typeId: 2) // Cambia l'ID del typeId se necessario
class HiveCampaign extends HiveObject {
  // @HiveField(0)
  // late List<Character> characters = [];

  // @HiveField(1)
  // late List<RollResult> rolls = [];

  @HiveField(0)
  late bool inCombat = false;

  @HiveField(1)
  late int currentTurn = 0;

  @HiveField(2)
  late String campaignTitle = 'Nuova Campagna';

  @HiveField(3)
  late Color? userColor;

  // @HiveField(4)
  // late int id;
}
