// characters.dart
import 'character.dart';
import 'dice.dart';

List<Character> getCharacters() {
  return [
    Character(2, 'Malakay'),
    //Character(1, 'Black Jack', 18),
    Character(1, 'Jericho'),
    Character(1, 'Merlok'),
    //Character(1, 'Durgan'),
    Character(1, 'Krom')
    // Character(2, 'Beholder', 16),
    // Character(1, 'Tarrasque', 17),
    // Character(6, 'Demogorgon', 7),
    // Character(1, 'Lucifer', 12),
  ];
}

List<RollHistoryEntry> getRolls() {
  return [
    RollHistoryEntry(
        roll: Roll(diceRolls: [DiceRoll(Dice.d20)], modifier: 2),
        title: 'Attacco Mannfred'),
    RollHistoryEntry(
        roll: Roll(diceRolls: [
          DiceRoll(Dice.d6),
          DiceRoll(Dice.d6),
          DiceRoll(Dice.d6)
        ]),
        title: 'Trappola palla di fuoco'),
    RollHistoryEntry(
        roll:
            RollFormula(dices: [Dice.d4, Dice.d4, Dice.d4], modifier: 2).roll(),
        title: 'Dardo arcano manipolatore'),
    // Roll(diceRolls: 'D20', : 9),
    // Roll(diceRolls: 'D4', : 2),
    // Roll(diceRolls: '2d4+1', : 7),
    // Roll(diceRolls: 'D10', : 3),
    // Roll(diceRolls: 'D6', : 6),
    // Roll(diceRolls: 'Attacco vampiro', : 12, formula: '2d8+2'),
    // Roll(diceRolls: 'Attacco manipolatore', formula: '2d6+4', : 13),
  ];
}
