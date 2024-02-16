import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/character.dart';
import 'package:dm_assistant/new_char_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitiativeTrackerNavigator extends StatelessWidget {
  const InitiativeTrackerNavigator({
    required this.onDrawer,
    super.key,
    //required this.appState,
  });

  final bool onDrawer;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return ListView(children: [
      if (onDrawer)
        ListTile(
            trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
      ListTile(
        leading: const Icon(Icons.group_add),
        title: const Text("Nuovo personaggio"),
        onTap: () async {
          if (onDrawer) {
            Navigator.pop(context);
          }
          final result = await showDialog<Character>(
            context: context,
            builder: (context) {
              return const NewCharDialog();
            },
          );
          if (result != null) {
            appState.addCharacter(
                result.name, result.initiativeBonus, result.initiativeScore);
          }
        },
      ),
      if (onDrawer)
        Divider(
            color: onDrawer
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onPrimary),
      ListTile(
        title: const Text("Personaggi non attivi"),
        trailing: Switch(
            value: appState.showDisabledChar,
            onChanged: appState.setDisabledChar),
      )
    ]);
  }
}
