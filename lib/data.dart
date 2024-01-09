// characters.dart
import 'character.dart';
import 'dice.dart';

List<Character> getCharacters() {
  return [
    Character(2, 'Malakay', 15),
    //Character(3, 'Black Jack', 18),
    Character(1, 'Jericho', 12),
    Character(4, 'Merlok', 20),
    Character(2, 'Durgan', 16),
    // Character(2, 'Beholder', 16),
    // Character(1, 'Tarrasque', 17),
    // Character(6, 'Demogorgon', 7),
    // Character(1, 'Lucifer', 12),
  ];
}

List<RollResult> getRolls() {
  return [
    RollResult(title: 'D20', result: 12),
    RollResult(title: 'D12', result: 12),
    RollResult(title: 'Attacco ghoul', result: 9, formula: '2d6+1'),
    RollResult(title: 'D20', result: 9),
    RollResult(title: 'D4', result: 2),
    RollResult(title: '2d4+1', result: 7),
    RollResult(title: 'D10', result: 3),
    RollResult(title: 'D6', result: 6),
    RollResult(title: 'Attacco vampiro', result: 12, formula: '2d8+2'),
    RollResult(title: 'Attacco manipolatore', formula: '2d6+4', result: 13),
  ];
}
