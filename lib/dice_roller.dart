import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/dice.dart';
import 'package:dm_assistant/home_page.dart';
import 'package:dm_assistant/rect_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiceRoller extends StatelessWidget {
  const DiceRoller({super.key});

  Widget mainPanel(context, constraints) {
    if (constraints.maxWidth < maxWidth) {
      return const RollHistory();
    } else {
      return const Row(
        children: [SavedRollList(), RollHistory()],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        color: Colors.black,
        child: Column(children: [
          Expanded(child: mainPanel(context, constraints)),
          const DicePanel(),
          const CustomRollPanel(),
        ]),
      );
    });
  }
}

class DicePanel extends StatelessWidget {
  const DicePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var buttonWidth = 60.0;
    void addRoll(Dice dice) {
      appState.addRollHistoryEntry(
          RollHistoryEntry(roll: RollFormula(dices: [dice]).roll()));
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
              top: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onPrimary))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D20'),
          onPressed: () {
            addRoll(Dice.d20);
          },
        ),
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D100'),
          onPressed: () {
            addRoll(Dice.d100);
          },
        ),
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D12'),
          onPressed: () {
            addRoll(Dice.d12);
          },
        ),
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D10'),
          onPressed: () {
            addRoll(Dice.d10);
          },
        ),
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D8'),
          onPressed: () {
            addRoll(Dice.d8);
          },
        ),
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D6'),
          onPressed: () {
            addRoll(Dice.d6);
          },
        ),
        RectButton(
          primary: false,
          width: buttonWidth,
          child: const Text('D4'),
          onPressed: () {
            addRoll(Dice.d4);
          },
        ),
      ]),
    );
  }
}

class CustomRollPanel extends StatefulWidget {
  const CustomRollPanel({
    super.key,
  });

  @override
  State<CustomRollPanel> createState() => _CustomRollPanelState();
}

class _CustomRollPanelState extends State<CustomRollPanel> {
  String rollString = '';
  bool isValid() {
    //return RollFormula.isValid(rollString);
    try {
      RollFormula.fromString(rollString);
      return true;
    } catch (diceParseException) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration:
                    const InputDecoration(labelText: 'Tiro personalizzato'),
                onChanged: (value) {
                  setState(() {
                    rollString = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            RectButton(
              primary: false,
              width: 60,
              icon: const Icon(Icons.save),
              onPressed: isValid() ? () {} : null,
            ),
            const SizedBox(width: 10),
            RectButton(
              primary: true,
              width: 60,
              icon: const Icon(Icons.send),
              onPressed: isValid()
                  ? () {
                      appState.addRollHistoryEntry(RollHistoryEntry(
                        roll: RollFormula.fromString(rollString).roll(),
                      ));
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class RollHistory extends StatefulWidget {
  const RollHistory({
    super.key,
  });

  @override
  State<RollHistory> createState() => _RollHistoryState();
}

class _RollHistoryState extends State<RollHistory> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var rolls = appState.rollHistory;
    appState.animatedRollHistoryListKey = _key;
    return Expanded(
      child: AnimatedList(
        key: _key,
        reverse: false,
        //shrinkWrap: true,
        initialItemCount: rolls.length,
        itemBuilder: (context, index, animation) {
          RollHistoryEntry roll = rolls[index];
          return SizeTransition(
              sizeFactor: animation, child: RollTile(roll: roll));
        },
      ),
    );
  }
}

class RollTile extends StatelessWidget {
  final RollHistoryEntry roll;

  const RollTile({
    super.key,
    required this.roll,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    Widget leading = Text(
      roll.roll.value.toString(),
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
      //style: const TextStyle(fontSize: 28),
    );
    Widget title = Text(roll.title ?? roll.roll.rollFormula,
        style: Theme.of(context).textTheme.bodyMedium);
    return SizedBox(
      height: 60,
      //width: 600,
      child: InkWell(
        onTap: () {
          appState.addRollHistoryEntry(RollHistoryEntry(
              roll: RollFormula.fromString(roll.roll.rollFormula).roll(),
              title: roll.title));
        },
        overlayColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return Theme.of(context)
                .colorScheme
                .inversePrimary
                .withOpacity(0.7);
          }
          return Colors.transparent;
        }),
        child: ListTile(
          horizontalTitleGap: 60,
          leading: leading,
          title: title,
          subtitle: roll.title != null
              ? Text(roll.roll.rollFormula,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary))
              : null,
        ),
      ),
    );
  }
}

class SavedRollList extends StatelessWidget {
  const SavedRollList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var savedRolls = appState.savedRolls;
    return Container(
      width: 300,
      decoration: BoxDecoration(
        //color: Colors.black,
        border: Border(
          right: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      child: ListView(
        children: savedRolls.map((savedRoll) {
          return InkWell(
            overlayColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.7);
              }
              return Colors.transparent;
            }),
            onTap: () {
              appState.addRollHistoryEntry(RollHistoryEntry(
                  roll: savedRoll.$1.roll(), title: savedRoll.$2));
            },
            child: ListTile(
              title: Text(
                savedRoll.$2,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(savedRoll.$1.toString()),
            ),
          );
        }).toList(),
      ),
    );
  }
}
