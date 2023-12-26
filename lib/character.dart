import 'status.dart';
import 'dart:math';

class Character {
  int initiativeBonus;
  int? initiativeScore; // può essere null
  String name;
  List<Status> status = []; // inizializzato come un array vuoto
  bool active = true; // inizializzato come true
  bool enabled = true;

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
