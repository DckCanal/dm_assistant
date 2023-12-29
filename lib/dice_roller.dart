import 'package:dm_assistant/dice.dart';
import 'package:dm_assistant/rect_button.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class DiceRoller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      //child: Text('Hi!'),
      child: Row(
        children: [
          //Text('Hi!'), Text('Hello!')
          SavedRollList(),
          Expanded(
            child: Column(children: [
              RollHistory(),
              DicePanel(),
              CustomRollPanel(),
            ]),
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
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
              top: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onPrimary))),
      child: Row(children: [
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D20'),
          onPressed: () {},
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D100'),
          onPressed: () {},
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D12'),
          onPressed: () {},
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D10'),
          onPressed: () {},
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D8'),
          onPressed: () {},
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D6'),
          onPressed: () {},
        ),
        RectButton(
          primary: false,
          width: 90,
          child: const Text('D4'),
          onPressed: () {},
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
    return Padding(
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
    );
  }
}

class RollHistory extends StatelessWidget {
  const RollHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<RollResult> rolls = getRolls();

    return Expanded(
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView.builder(
            //key: const PageStorageKey('InitiativeTrackerListView'),
            itemCount: rolls.length,

            //controller: scrollController,
            itemBuilder: (context, index) {
              return SizedBox(
                  height: 80, child: Card(child: RollTile(roll: rolls[index])));
            },
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
    //return ListView();
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          right: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      child: Center(child: Text('Tiri salvati')),
    );
  }
}

class RollTile extends StatelessWidget {
  const RollTile({
    super.key,
    required this.roll,
  });

  final RollResult roll;

  @override
  Widget build(BuildContext context) {
    if (roll.formula != null) {
      return ListTile(
        leading: Text(roll.result.toString()),
        title: Text(roll.title),
        subtitle: Text(roll.formula ?? ''),
      );
    } else {
      return ListTile(
        leading: Text(roll.result.toString()),
        title: Text(roll.title),
      );
    }
  }
}
