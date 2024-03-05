import 'package:dm_assistant/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class InitiativeTrackerNavigator extends StatelessWidget {
  const InitiativeTrackerNavigator({
    required this.onDrawer,
    super.key,
  });

  final bool onDrawer;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return ListView(children: [
      ListTile(
        title: const Text("Personaggi non attivi"),
        trailing: Switch(
            value: appState.showDisabledChar,
            onChanged: appState.setDisabledChar),
      ),
      ListTile(
        title: const Text("Colore principale"),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Scegli un colore'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: appState.userColor,
                    onColorChanged: appState.changeColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    ]);
  }
}
