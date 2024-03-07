import 'package:flutter_test/flutter_test.dart';
import 'package:dm_assistant/dice.dart';

void main() {
  test('Test toString() method on Roll class without modifier', () {
    List<DiceRoll> diceRolls = [
      DiceRoll.withValue(Dice.d6, 3),
      DiceRoll.withValue(Dice.d6, 2),
      DiceRoll.withValue(Dice.d20, 15),
      DiceRoll.withValue(Dice.d12, 5),
    ];
    Roll roll = Roll(diceRolls: diceRolls);
    expect(roll.toString(), 'd6(3)+d6(2)+d20(15)+d12(5)');
  });
  test('Test toString() method on Roll class with modifier', () {
    List<DiceRoll> diceRolls = [
      DiceRoll.withValue(Dice.d6, 3),
      DiceRoll.withValue(Dice.d6, 2),
      DiceRoll.withValue(Dice.d20, 15),
      DiceRoll.withValue(Dice.d12, 5),
    ];
    int modifier = 5;
    Roll roll = Roll(diceRolls: diceRolls, modifier: modifier);
    expect(roll.toString(), 'd6(3)+d6(2)+d20(15)+d12(5)+5');
  });

  test('Test fromString(...) method on Roll class without modifier', () {
    String str = 'd6(3)+d6(2)+d20(15)+d12(5)+d100(54)';
    List<DiceRoll> diceRolls = [
      DiceRoll.withValue(Dice.d6, 3),
      DiceRoll.withValue(Dice.d6, 2),
      DiceRoll.withValue(Dice.d20, 15),
      DiceRoll.withValue(Dice.d12, 5),
      DiceRoll.withValue(Dice.d100, 54)
    ];
    Roll roll1 = Roll.fromString(str);
    Roll roll2 = Roll(diceRolls: diceRolls);
    expect(roll1, roll2);
  });

  test('Test fromString(...) method on Roll class with modifier', () {
    String str = 'd6(3)+d6(2)+d20(15)+d12(5)+d100(54)+4';
    List<DiceRoll> diceRolls = [
      DiceRoll.withValue(Dice.d6, 3),
      DiceRoll.withValue(Dice.d6, 2),
      DiceRoll.withValue(Dice.d20, 15),
      DiceRoll.withValue(Dice.d12, 5),
      DiceRoll.withValue(Dice.d100, 54)
    ];
    Roll roll1 = Roll.fromString(str);
    Roll roll2 = Roll(diceRolls: diceRolls, modifier: 4);
    expect(roll1, roll2);
  });
}
