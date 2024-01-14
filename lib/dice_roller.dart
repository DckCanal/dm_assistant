//import 'package:dm_assistant/dice.dart';
import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/dice.dart';
import 'package:dm_assistant/rect_button.dart';
import 'package:dm_assistant/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'data.dart';

class DiceRoller extends StatelessWidget {
  const DiceRoller({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.black,
      child: const Row(
        children: [
          //SavedRollList(),
          Expanded(
            child: Material(
              color: Colors.black,
              child: Column(children: [
                RollHistory(),
                DicePanel(),
                CustomRollPanel(),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class DicePanel extends StatelessWidget {
  const DicePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
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
          width: 90,
          child: const Text('D20'),
          onPressed: () {
            addRoll(Dice.d20);
          },
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D100'),
          onPressed: () {
            addRoll(Dice.d100);
          },
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D12'),
          onPressed: () {
            addRoll(Dice.d12);
          },
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D10'),
          onPressed: () {
            addRoll(Dice.d10);
          },
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D8'),
          onPressed: () {
            addRoll(Dice.d8);
          },
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D6'),
          onPressed: () {
            addRoll(Dice.d6);
          },
        ),
        RectButton(
          primary: false,
          width: 90,
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
  @override
  Widget build(BuildContext context) {
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
            RectButton(
              primary: true,
              width: 60,
              icon: const Icon(Icons.send),
              onPressed: () {},
            )
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
  final ScrollController _controller = ScrollController();
  //List<RollHistoryEntry> rolls = getRolls();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var rolls = context.watch<AppState>().rollHistory;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: ListView.separated(
            itemCount: rolls.length,
            key: const PageStorageKey('RollHistoryListView'),
            controller: _controller,
            separatorBuilder: (BuildContext context, int index) {
              //return const SizedBox(height: 6);
              return Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                thickness: 1,
                height: 1,
              );
            },
            itemBuilder: (context, index) {
              // return Container(height: 70, child: RollTile(roll: rolls[index]));
              return RollTile(roll: rolls[index]);
            },
          ),
        ),
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
      style: Theme.of(context).textTheme.titleLarge,
    );
    Widget title = Text(roll.title ?? roll.roll.rollFormula);
    return InkWell(
      onTap: () {
        appState.addRollHistoryEntry(RollHistoryEntry(
            roll: RollFormula.fromString(roll.roll.rollFormula).roll(),
            title: roll.title));
      },
      child: SizedBox(
        height: 100,
        child: Center(
          child: ListTile(
            horizontalTitleGap: 40,
            dense: false,
            leading: leading,
            title: title,
            subtitle: roll.title != null ? Text(roll.roll.rollFormula) : null,
          ),
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
    return Container(
      width: 500,
      decoration: BoxDecoration(
        //color: Colors.black,
        border: Border(
          right: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      child: const Center(child: Text('Tiri salvati')),
    );
  }
}
