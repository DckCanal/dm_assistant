import 'package:flutter/material.dart';
import 'character.dart';
import 'rect_button.dart';

class CharTile extends StatelessWidget {
  final Character character;
  final VoidCallback onDelete, onEnable, onDisable;
  final void Function(int) onSetInitiativeScore;
  final bool roundOwner;

  const CharTile(
      {required this.character,
      required this.onDelete,
      required this.onEnable,
      required this.onDisable,
      required this.onSetInitiativeScore,
      this.roundOwner = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: !character.enabled
            ? Theme.of(context).colorScheme.surface
            : (roundOwner == true
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.black),
        border: Border.all(
            color: character.enabled
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.onInverseSurface,
            width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: roundOwner
            ? [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(2, 3),
                ),
              ]
            : null,
      ),
      child: SizedBox(
        height: 100,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final result = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          int initiativeScore = character.initiativeScore ?? 0;
                          // final FocusNode unitCodeCtrlFocusNode = FocusNode();
                          // unitCodeCtrlFocusNode.requestFocus();
                          return InitiativeDialog(
                              initiativeScore: initiativeScore);
                        },
                      );
                      if (result != null) {
                        onSetInitiativeScore(result);
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
                  Text(character.name),
                ],
              ),
              SizedBox(
                width: 140,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RectButton(
                        primary: false,
                        height: 60,
                        width: 60,
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 20),
                      RectButton(
                          primary: false,
                          onPressed: character.enabled ? onDisable : onEnable,
                          height: 60,
                          width: 60,
                          icon: const Icon(Icons.no_accounts))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InitiativeDialog extends StatefulWidget {
  final int initiativeScore;

  InitiativeDialog({required this.initiativeScore});

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
