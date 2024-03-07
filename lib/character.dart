import 'dart:math';
import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 3)
class Character extends HiveObject {
  @HiveField(0)
  int initiativeBonus;

  @HiveField(1)
  int? initiativeScore; // può essere null

  @HiveField(2)
  String name;

  @HiveField(3)
  bool enabled = true;

  // @HiveField(4)
  // bool active = true; // inizializzato come true

  @HiveField(4)
  HiveList? statuses;

  Character(this.initiativeBonus, this.name, [this.initiativeScore]) {
    initiativeScore ??= initiativeBonus + Random().nextInt(20) + 1;
  }

  void rollInitiative() {
    initiativeScore = initiativeBonus + Random().nextInt(20) + 1;
  }

  void enable() {
    enabled = true;
  }

  void disable() {
    enabled = false;
  }
}
