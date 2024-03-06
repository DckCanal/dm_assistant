import 'package:flutter/material.dart';
import 'character.dart';
import 'rect_button.dart';
import 'app_state.dart';
import 'round_button.dart';
import 'package:provider/provider.dart';

class CharTile extends StatelessWidget {
  final Character character;
  final bool roundOwner;

  const CharTile({required this.character, this.roundOwner = false, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var textTheme = switch (character.enabled) {
      true => Theme.of(context).textTheme.bodyLarge,
      false => Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: Colors.grey)
          .copyWith(decoration: TextDecoration.lineThrough),
    };
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onTap: () {
          if (appState.inCombat && character.enabled) {
            appState.setRoundOwner(character);
          }
        },
        overlayColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return Theme.of(context)
                .colorScheme
                .inversePrimary
                .withOpacity(0.7);
          }
          return Colors.black;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80,
          decoration: BoxDecoration(
            color: !character.enabled
                ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
                : (roundOwner == true
                    ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)
                    : Colors.black.withOpacity(0.3)),
            boxShadow: null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            
            RoundButton(
              primary: false,
              onPressed: () async {
                final result = await showDialog<int>(
                  context: context,
                  builder: (context) {
                    int initiativeScore = character.initiativeScore ?? 0;
                    return InitiativeDialog(initiativeScore: initiativeScore);
                  },
                );
                if (result != null) {
                  appState.setCharacterInitiativeScore(character, result);
                }
              },
              child: Text(
                character.initiativeScore.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Text(character.name,
                    overflow: TextOverflow.ellipsis, style: textTheme)),
            RectButton(
              primary: false,
              height: 40,
              width: 40,
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
                height: 40,
                width: 40,
                icon: const Icon(Icons.no_accounts))
          ]),
        ),
      );
    });
  }
}

class InitiativeDialog extends StatefulWidget {
  final int initiativeScore;

  const InitiativeDialog({required this.initiativeScore, super.key});

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
          color: Colors.black, 
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
            Row(
              children: [
                const Spacer(),
                RectButton(
                  primary: false,
                  width: 75,
                  onPressed: () {
                    Navigator.of(context).pop(initiativeScore);
                  },
                  child: const Text('OK'),
                ),
              ],
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
