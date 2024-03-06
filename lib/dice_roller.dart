import 'dart:io';

import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/dice.dart';
import 'package:dm_assistant/rect_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiceRoller extends StatelessWidget {
  const DiceRoller({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const Material(
        color: Colors.black,
        child: Column(children: [
          Expanded(child: RollHistory()),
           DicePanel(),
        ]),
      );
    });
  }
}

class DicePanel extends StatefulWidget {
  const DicePanel({
    super.key,
  });

  @override
  State<DicePanel> createState() => _DicePanelState();
}

class _DicePanelState extends State<DicePanel> {
  final buttonWidth = 60.0;
  bool _savedRollViewEnabled = false;
  Widget _d20(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D20'),
      onPressed: () {
        addRoll(Dice.d20);
      },
    );
  }

  Widget _d100(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D100'),
      onPressed: () {
        addRoll(Dice.d100);
      },
    );
  }

  Widget _d12(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D12'),
      onPressed: () {
        addRoll(Dice.d12);
      },
    );
  }

  Widget _d10(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D10'),
      onPressed: () {
        addRoll(Dice.d10);
      },
    );
  }

  Widget _d8(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D8'),
      onPressed: () {
        addRoll(Dice.d8);
      },
    );
  }

  Widget _d6(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D6'),
      onPressed: () {
        addRoll(Dice.d6);
      },
    );
  }

  Widget _d4(addRoll) {
    return RectButton(
      primary: false,
      width: buttonWidth,
      child: const Text('D4'),
      onPressed: () {
        addRoll(Dice.d4);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    void addRoll(Dice dice) {
      appState.addRollHistoryEntry(
          RollHistoryEntry(roll: RollFormula(dices: [dice]).roll()));
    }

    List<Widget> diceList = [
      RectButton(
        primary: false,
        width: buttonWidth,
        child: const Icon(Icons.other_houses),
        onPressed: () {
          setState(() {
            _savedRollViewEnabled = !_savedRollViewEnabled;
          });
        },
      ),
      _d20(addRoll),
      _d100(addRoll),
      _d12(addRoll),
      _d10(addRoll),
      _d8(addRoll),
      _d6(addRoll),
      _d4(addRoll),
    ];

    Widget bottomPanel() {
      if (_savedRollViewEnabled == true) {
        return Column(
          children: [
            ListTile(
              title: const Text("Tiri salvati"),
              trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _savedRollViewEnabled = !_savedRollViewEnabled;
                    });
                  }),
            ),
            const Expanded(child: SavedRollList()),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 480) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: diceList);
              } else if (Platform.isAndroid || Platform.isIOS) {
                return SizedBox(
                  height: 46,
                  child: ListView(
                      scrollDirection: Axis.horizontal, children: diceList),
                );
              } else {
                return SizedBox(
                    height: 110,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: diceList.sublist(0, 4),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: diceList.sublist(4, 8),
                      )
                    ]));
              }
            }),
            const CustomRollPanel(),
          ],
        );
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _savedRollViewEnabled
              ? 300
              : (Platform.isAndroid ||
                      Platform.isIOS ||
                      constraints.maxWidth > 510
                  ? 160
                  : 220),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                  top: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.onPrimary))),
          child: bottomPanel());
    });
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
              onPressed: isValid()
                  ? () async {
                      final result = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return const NewRollDialog();
                          });
                      if (result != null) {
                        appState.addSavedRoll(
                            RollFormula.fromString(rollString), result);
                      }
                    }
                  : null,
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

class NewRollDialog extends StatefulWidget {
  const NewRollDialog({
    super.key,
  });

  @override
  State<NewRollDialog> createState() => _NewRollDialogState();
}

class _NewRollDialogState extends State<NewRollDialog> {
  String? rollTitle;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    rollTitle = value;
                  },
                  onSubmitted: (value) {
                    Navigator.of(context).pop(rollTitle);
                  },
                  focusNode: focusNode,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 50),
                RectButton(
                    primary: true,
                    width: 125,
                    onPressed: () {
                      Navigator.of(context).pop(rollTitle);
                    },
                    child: const Text('Salva'))
              ],
            )));
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
    return AnimatedList(
      key: _key,
      reverse: false,
      initialItemCount: rolls.length,
      itemBuilder: (context, index, animation) {
        RollHistoryEntry roll = rolls[index];
        return SizeTransition(
            sizeFactor: animation, child: RollTile(roll: roll));
      },
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
    );
    Widget title = Text(roll.title ?? roll.roll.rollFormula,
        style: Theme.of(context).textTheme.bodyMedium);
    return SizedBox(
      height: 60,
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

class SavedRollList extends StatefulWidget {
  const SavedRollList({
    super.key,
  });

  @override
  State<SavedRollList> createState() => _SavedRollListState();
}

class _SavedRollListState extends State<SavedRollList> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var savedRolls = appState.savedRolls;
    appState.animatedSavedRollListKey = _key;
    return Material(
      color: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        child: AnimatedList(
          key: _key,
          initialItemCount: savedRolls.length,
          itemBuilder: (context, index, animation) {
            (RollFormula, String) savedRoll = savedRolls[index];
            return SizeTransition(
                sizeFactor: animation,
                child: SavedRollTile(savedRoll: savedRoll));
          },
        ),
      ),
    );
  }
}

class SavedRollTile extends StatelessWidget {
  const SavedRollTile({
    super.key,
    required this.savedRoll,
  });

  final (RollFormula, String) savedRoll;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return InkWell(
      overlayColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7);
        }
        return Colors.transparent;
      }),
      onTap: () {
        appState.addRollHistoryEntry(
            RollHistoryEntry(roll: savedRoll.$1.roll(), title: savedRoll.$2));
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
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            appState.removeSavedRoll(savedRoll.$1, savedRoll.$2);
          },
        ),
      ),
    );
  }
}
