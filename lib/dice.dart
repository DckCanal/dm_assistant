import 'dart:math';

// class RollResult {
//   final String title;
//   final String? formula;
//   final int result;

//   RollResult({required this.title, required this.result, this.formula});
// }

enum Dice { d100, d20, d12, d10, d8, d6, d4 }

// Rappresentazione di un tiro di dado semplice
// int risultato = DiceRoll(Dice.d20).value
class DiceRoll {
  final Dice dice;
  late int value;
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

  //TODO: create roll Formula
  String get rollFormula => '2d6 + d8 + 3';

  //rolls.fold(0, (sum, roll) => sum + roll.value) + modifier;
  Roll({required this.diceRolls, this.modifier = 0});
}

// Usage: RollFormula(dices: [Dice.d6, Dice.d6, Dice.d4], modifier=3).roll().value;
class RollFormula {
  final List<Dice> dices;
  final int modifier;

  RollFormula({required this.dices, this.modifier = 0});

  Roll roll() {
    return Roll(
        diceRolls: dices.map((dice) => DiceRoll(dice)).toList(),
        modifier: modifier);
  }
}

// Rappresentazione del singolo tiro di dado con modificatore
// class BaseRoll {
//   final Dice dice;
//   final int modifier;
//   BaseRoll({required this.dice, this.modifier = 0});

//   BaseRollResult roll() {
//     switch (dice) {
//       case Dice.d100:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(100) + 1 + modifier);
//       case Dice.d20:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(20) + 1 + modifier);
//       case Dice.d12:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(12) + 1 + modifier);
//       case Dice.d10:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(10) + 1 + modifier);
//       case Dice.d8:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(8) + 1 + modifier);
//       case Dice.d6:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(6) + 1 + modifier);
//       case Dice.d4:
//         return BaseRollResult(
//             roll: this, value: Random().nextInt(4) + 1 + modifier);
//       default:
//         throw Exception('Unknown dice');
//     }
//   }
// }

// // Rappresentazione del tiro di dado con un modificatore
// class BaseRollResult {
//   final BaseRoll roll;
//   final int value;

//   int get result => value + roll.modifier;

//   BaseRollResult({required this.roll, required this.value});
// }

// class ComplexRoll {
//   final List<Dice> dices;
//   final int modifier;

//   ComplexRoll({required this.dices, this.modifier = 0});
// }

// // Rappresentazione di un tiro di dado complesso, dato dall'unione di più tiri
// class ComplexRollResult {
//   final List<BaseRoll> rolls;
//   final int modifier;

//   // int get result => rolls
//   //     .map((roll) => roll.value)
//   //     .reduce((value, element) => value += element);
//   int get result => rolls.fold(0, (sum, roll) => sum + roll.value) + modifier;

//   ComplexRollResult({required this.rolls, this.modifier = 0});
// }

class RollHistoryEntry {
  final Roll roll;
  final String title;
  RollHistoryEntry({required this.roll, this.title = ''});
}
