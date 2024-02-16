// characters.dart
import 'character.dart';
import 'dice.dart';

List<Character> getCharacters() {
  return [
    Character(3, 'Malakay'),
    //Character(1, 'Black Jack', 18),
    Character(2, 'Jericho'),
    Character(1, 'Merlok'),
    //Character(1, 'Durgan'),
    Character(7, 'Krom')
    // Character(2, 'Beholder', 16),
    // Character(1, 'Tarrasque', 17),
    // Character(6, 'Demogorgon', 7),
    // Character(1, 'Lucifer', 12),
  ];
}

List<(RollFormula roll, String title)> getSavedRolls() {
  return [
    (RollFormula.fromString("2d6+3d4+1"), "Attacco Ghoul"),
    (RollFormula.fromString("d20+7"), "Tiro per colpire Vampiro"),
    (RollFormula.fromString("1d20+5"), "TS DES ladro"),
    (RollFormula.fromString("3d4+3"), "Dardo incantato")
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
    RollHistoryEntry(roll: RollFormula.fromString('2d6+d4+3').roll()),
    // Roll(diceRolls: 'D20', : 9),
    // Roll(diceRolls: 'D4', : 2),
    // Roll(diceRolls: '2d4+1', : 7),
    // Roll(diceRolls: 'D10', : 3),
    // Roll(diceRolls: 'D6', : 6),
    // Roll(diceRolls: 'Attacco vampiro', : 12, formula: '2d8+2'),
    // Roll(diceRolls: 'Attacco manipolatore', formula: '2d6+4', : 13),
  ];
}
