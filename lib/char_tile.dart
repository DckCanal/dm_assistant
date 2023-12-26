import 'package:flutter/material.dart';
import 'character.dart';
import 'rect_button.dart';

class CharTile extends StatelessWidget {
  final Character character;
  final VoidCallback onDelete, onEnable, onDisable;
  final bool roundOwner;

  const CharTile(
      {required this.character,
      required this.onDelete,
      required this.onEnable,
      required this.onDisable,
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
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Text(
              character.initiativeScore.toString(),
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            ),
            title: Text(character.name),
            trailing: SizedBox(
              width: 140,
              //height: 100,
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
                    RectButton(
                        primary: false,
                        onPressed: character.enabled ? onDisable : onEnable,
                        height: 60,
                        width: 60,
                        icon: const Icon(Icons.no_accounts))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
