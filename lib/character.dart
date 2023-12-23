import 'status.dart';

class Character {
  int initiativeBonus;
  int? initiativeRoll; // può essere null
  String name;
  List<Status> status = []; // inizializzato come un array vuoto
  bool active = true; // inizializzato come true

  Character({
    required this.initiativeBonus,
    this.initiativeRoll, // può essere null
    required this.name,
    // status e active hanno già valori iniziali, quindi non sono richiesti nel costruttore
  });
}
