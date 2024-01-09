import 'package:flutter/material.dart';
import 'character.dart';
import 'rect_button.dart';
import 'app_state.dart';
import 'package:provider/provider.dart';

class CharTile extends StatelessWidget {
  final Character character;
  // final VoidCallback onDelete, onEnable, onDisable;
  // final void Function(int) onSetInitiativeScore;
  final bool roundOwner;

  const CharTile(
      {required this.character,
      // required this.onDelete,
      // required this.onEnable,
      // required this.onDisable,
      // required this.onSetInitiativeScore,
      this.roundOwner = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: !character.enabled
              ? Theme.of(context).colorScheme.surface
              : (roundOwner == true
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.black),
          border: //constraints.maxWidth <= 600 ?
              null,
          // : Border.all(
          //     color: character.enabled
          //         ? Theme.of(context).colorScheme.inversePrimary
          //         : Theme.of(context).colorScheme.onInverseSurface,
          //     width: 2),
          borderRadius: BorderRadius.circular(10),
          // boxShadow: roundOwner && constraints.maxWidth > 600
          //     ? [
          //         BoxShadow(
          //           color: Theme.of(context)
          //               .colorScheme
          //               .inversePrimary
          //               .withOpacity(0.2),
          //           spreadRadius: 3,
          //           blurRadius: 4,
          //           offset: const Offset(2, 3),
          //         ),
          //       ]
          //     : null,
          boxShadow: null,
        ),
        //color: Colors.green,
        //width: ,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          OutlinedButton(
            onPressed: () async {
              final result = await showDialog<int>(
                context: context,
                builder: (context) {
                  int initiativeScore = character.initiativeScore ?? 0;
                  // final FocusNode unitCodeCtrlFocusNode = FocusNode();
                  // unitCodeCtrlFocusNode.requestFocus();
                  return InitiativeDialog(initiativeScore: initiativeScore);
                },
              );
              if (result != null) {
                //onSetInitiativeScore(result);
                appState.setCharacterInitiativeScore(character, result);
              }
            },
            child: SizedBox(
              height: 60,
              width: 50,
              child: Center(
                child: Text(
                  character.initiativeScore.toString(),
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
              child: Text(character.name, overflow: TextOverflow.ellipsis)),
          RectButton(
            primary: false,
            height: 60,
            width: 60,
            onPressed: () => appState.removeCharacter(character),
            icon: const Icon(
              Icons.delete,
              size: 20,
            ),
          ),
          const SizedBox(width: 20),
          RectButton(
              primary: false,
              onPressed: character.enabled
                  ? () => appState.disableCharacter(character)
                  : () => appState.enableCharacter(character),
              height: 60,
              width: 60,
              icon: const Icon(Icons.no_accounts))
        ]),
        //     SizedBox(
        //       width: 140,
        //       child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [

        //     ),
        //   ],
        // ),
      );
    });
  }
}

class InitiativeDialog extends StatefulWidget {
  final int initiativeScore;

  InitiativeDialog({required this.initiativeScore, super.key});

  @override
  _InitiativeDialogState createState() => _InitiativeDialogState();
}

class _InitiativeDialogState extends State<InitiativeDialog> {
  late TextEditingController controller;
  int? initiativeScore;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initiativeScore = widget.initiativeScore;
    controller = TextEditingController(text: '${widget.initiativeScore}');
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Iniziativa'),
              focusNode: focusNode,
              controller: controller,
              onChanged: (value) {
                initiativeScore = int.tryParse(value) ?? 0;
              },
              onSubmitted: (value) {
                Navigator.of(context).pop(initiativeScore);
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 50),
            RectButton(
              primary: true,
              width: 125,
              onPressed: () {
                Navigator.of(context).pop(initiativeScore);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}
