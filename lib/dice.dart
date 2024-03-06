import 'dart:math';

enum Dice { d100, d20, d12, d10, d8, d6, d4 }

extension DiceExtension on Dice {
  String get representation {
    return toString().split('.').last;
  }
}

// Rappresentazione di un tiro di dado semplice
// int risultato = DiceRoll(Dice.d20).value
class DiceRoll {
  final Dice dice;
  late int value;
  String get formula {
    switch (dice) {
      case Dice.d100:
        return 'd100';
      case Dice.d20:
        return 'd20';
      case Dice.d12:
        return 'd12';
      case Dice.d10:
        return 'd10';
      case Dice.d8:
        return 'd8';
      case Dice.d6:
        return 'd6';
      case Dice.d4:
        return 'd4';
      default:
        throw Exception('Unknown dice');
    }
  }

  DiceRoll(this.dice) {
    switch (dice) {
      case Dice.d100:
        value = Random().nextInt(100) + 1;
        break;
      case Dice.d20:
        value = Random().nextInt(20) + 1;
        break;
      case Dice.d12:
        value = Random().nextInt(12) + 1;
        break;
      case Dice.d10:
        value = Random().nextInt(10) + 1;
        break;
      case Dice.d8:
        value = Random().nextInt(8) + 1;
        break;
      case Dice.d6:
        value = Random().nextInt(6) + 1;
        break;
      case Dice.d4:
        value = Random().nextInt(4) + 1;
        break;
      default:
        throw Exception('Unknown dice');
    }
  }
}

class Roll {
  final List<DiceRoll> diceRolls;
  final int modifier;

  int get value =>
      diceRolls.fold(0, (sum, roll) => sum + roll.value) + modifier;

  String get rollFormula {
    // Raggruppa i dadi dello stesso tipo nella formula
    Map<Dice, int> diceCounts = {};

    for (DiceRoll roll in diceRolls) {
      diceCounts.update(roll.dice, (count) => count + 1, ifAbsent: () => 1);
    }

    String formula = diceCounts.entries
        .map((entry) => entry.value > 1
            ? '${entry.value}${entry.key.representation}'
            : entry.key.representation)
        .join(' + ');

    if (modifier != 0) {
      return '$formula + $modifier';
    }
    return formula;
  }

  @override
  String toString() {
    return rollFormula;
  }

  Roll({required this.diceRolls, this.modifier = 0});
}

// Usage: RollFormula(dices: [Dice.d6, Dice.d6, Dice.d4], modifier=3).roll().value;
// or: RollFormula.fromString('2d6+d8+3').roll();
class RollFormula {
  final List<Dice> dices;
  final int modifier;

  RollFormula({required this.dices, this.modifier = 0});

  factory RollFormula.fromString(String formula) {
    try {
      List<String> components = formula.split('+');
      List<Dice> dices = [];
      int modifier = 0;

      for (String component in components) {
        String trimmedComponent = component.trim();
        List<String> parts = trimmedComponent.split('d');

        if (parts.length == 2) {
          // Se la parte è composta da due elementi, allora rappresenta un dado
          int quantity = parts[0].isEmpty ? 1 : int.parse(parts[0]);
          Dice dice = _parseDice(parts[1]);
          dices.addAll(List.generate(quantity, (_) => dice));
        } else if (parts.length == 1) {
          // Se la parte è composta da un solo elemento, allora rappresenta un modificatore
          modifier += int.parse(parts[0]);
        } else {
          throw DiceParseException("Errore nella formula: $formula");
        }
      }

      return RollFormula(dices: dices, modifier: modifier);
    } catch (e) {
      throw DiceParseException("Errore nella formula: $formula");
    }
  }

  static Dice _parseDice(String diceString) {
    switch (diceString) {
      case '100':
        return Dice.d100;
      case '20':
        return Dice.d20;
      case '12':
        return Dice.d12;
      case '10':
        return Dice.d10;
      case '8':
        return Dice.d8;
      case '6':
        return Dice.d6;
      case '4':
        return Dice.d4;
      default:
        throw DiceParseException("Tipo di dado non valido: $diceString");
    }
  }

  @override
  String toString() {
    // Compatta i dadi della stessa categoria nella rappresentazione
    Map<Dice, int> diceCounts = {};

    for (Dice dice in dices) {
      diceCounts.update(dice, (count) => count + 1, ifAbsent: () => 1);
    }

    String formula = diceCounts.entries
        .map((entry) => entry.value > 1
            ? '${entry.value}${entry.key.representation}'
            : entry.key.representation)
        .join('+');

    // Aggiungi il modificatore
    if (modifier != 0) {
      String modifierSign = modifier > 0 ? '+' : '';
      formula += '$modifierSign$modifier';
    }

    return formula;
  }

  static String compactFormula(String formula) {
    // Split della formula in base al carattere '+'
    List<String> parts = formula.split('+');

    // Mappa per tenere traccia del numero di volte che appare ciascun tipo di dado
    Map<String, int> diceCounts = {};

    for (String part in parts) {
      // Rimozione di spazi vuoti
      String cleanPart = part.trim();

      // Estrazione del numero (se presente)
      String count = cleanPart.replaceAll(RegExp(r'[^0-9]'), '');

      // Estrazione del tipo di dado
      String diceType = cleanPart.replaceAll(RegExp(r'[0-9]'), '');

      // Aggiornamento della mappa di conteggio
      diceCounts.update(diceType, (value) => value + int.parse(count),
          ifAbsent: () => int.parse(count));
    }

    // Costruzione della formula compatta
    String compactFormula = diceCounts.entries
        .map((entry) =>
            entry.value > 1 ? '${entry.value}${entry.key}' : entry.key)
        .join('+');

    return compactFormula;
  }

  static String combineFormula({
    String initialFormula = '',
    List<Dice> newDices = const [],
    int newModifier = 0,
  }) {
    // Aggiungi la formula iniziale se presente
    String result = initialFormula.isNotEmpty ? initialFormula : '';

    // Aggiungi nuovi dadi
    if (newDices.isNotEmpty) {
      String newDiceFormula =
          newDices.map((dice) => dice.representation).join('+');
      result += result.isNotEmpty ? '+$newDiceFormula' : newDiceFormula;
    }

    // Aggiungi nuovo modificatore
    if (newModifier != 0) {
      String modifierSign = newModifier > 0 ? '+' : '';
      result +=
          result.isNotEmpty ? '$modifierSign$newModifier' : '$newModifier';
    }

    return compactFormula(result);
  }

  Roll roll() {
    return Roll(
        diceRolls: dices.map((dice) => DiceRoll(dice)).toList(),
        modifier: modifier);
  }
}

class RollHistoryEntry {
  final Roll roll;
  final String? title;
  RollHistoryEntry({required this.roll, this.title});

  @override
  String toString() {
    return '$title: ${roll.toString()}';
  }
}

class DiceParseException implements Exception {
  final String message;

  DiceParseException(this.message);

  @override
  String toString() {
    return "DiceParseException: $message";
  }
}
