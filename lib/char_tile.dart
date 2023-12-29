import 'package:flutter/material.dart';
import 'character.dart';
import 'rect_button.dart';
import 'initiative_dialog.dart';

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
    return Card(
      surfaceTintColor: Colors.transparent,
      color: !character.enabled
          ? Theme.of(context).colorScheme.surface
          : (roundOwner == true
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.black),
      child: SizedBox(
        height: 100,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: character.enabled
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.onInverseSurface,
                  width: 2),
              borderRadius: BorderRadius.circular(10)),
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
