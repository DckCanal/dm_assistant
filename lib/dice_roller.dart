import 'package:dm_assistant/dice.dart';
import 'package:dm_assistant/rect_button.dart';
import 'package:dm_assistant/round_button.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class DiceRoller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Row(
        children: [
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
      padding: const EdgeInsets.all(12),
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

class RollHistory extends StatefulWidget {
  const RollHistory({
    super.key,
  });

  @override
  State<RollHistory> createState() => _RollHistoryState();
}

class _RollHistoryState extends State<RollHistory> {
  final ScrollController _controller = ScrollController();
  List<RollResult> rolls = getRolls();

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
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView.separated(
            itemCount: rolls.length,
            key: const PageStorageKey('RollHistoryListView'),
            controller: _controller,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 6);
            },
            itemBuilder: (context, index) {
              return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RollTile(roll: rolls[index]));
            },
          ),
        ),
      ),
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
    Widget leading = Text(
      roll.result.toString(),
      style: Theme.of(context).textTheme.titleLarge,
    );
    Widget title = Text(roll.title);
    Widget trailing = RoundButton(
        radius: 40,
        primary: false,
        icon: const Icon(Icons.refresh, size: 24),
        onPressed: () {});
    if (roll.formula != null) {
      return Center(
        child: ListTile(
          horizontalTitleGap: 40,
          dense: true,
          leading: leading,
          title: title,
          subtitle: Text(roll.formula ?? ''),
          trailing: trailing,
        ),
      );
    } else {
      return Center(
        child: ListTile(
          horizontalTitleGap: 40,
          dense: true,
          leading: leading,
          title: title,
          trailing: trailing,
        ),
      );
    }
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
        color: Colors.black,
        border: Border(
          right: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      child: const Center(child: Text('Tiri salvati')),
    );
  }
}
