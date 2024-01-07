import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'active_character_list.dart';
import 'initiative_tracker_control_bar.dart';
import 'app_state.dart';

class InitiativeTracker extends StatelessWidget {
  const InitiativeTracker({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Container(
      color: Colors.black,
      child: Column(children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Row(
              children: [
                constraints.maxWidth >= 800
                    ? const DisabledCharacterList()
                    : const DisabledCharacterDrawer(),
                const Expanded(
                  child: ActiveCharacterList(),
                ),
              ],
            );
          }),
        ),
        const InitiativeTrackerControlBar(),
      ]),
    );
  }
}

class DisabledCharacterList extends StatelessWidget {
  const DisabledCharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Widget> charList = appState.characters
        .where(
          (char) => !char.enabled,
        )
        .map((char) => SizedBox(
              width: 280,
              child: ListTile(
                  title: Text(char.name),
                  subtitle: Text('Iniziativa ${char.initiativeScore}'),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   visualDensity: VisualDensity.compact,
                  //   onPressed: () {
                  //     onRemoveCharacter(char);
                  //   },
                  // ),
                  onTap: () {
                    appState.enableCharacter(char);
                  }),
            ))
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInExpo,
      width: appState.characters.isNotEmpty ? 300 : 0,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: charList,
      ),
    );
  }
}

class DisabledCharacterDrawer extends StatelessWidget {
  const DisabledCharacterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Widget> charList = appState.characters
        .map((char) => ListTile(
              title: Text(char.name),
              subtitle: Text('Iniziativa ${char.initiativeScore}'),
              onTap: () {
                appState.enableCharacter(char);
              },
            ))
        .toList();

    // Aggiungi il DrawerHeader come primo elemento della ListView
    // TODO: fix bug!
    charList.insert(
      0,
      DrawerHeader(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Fuori combattimento'),
          IconButton(onPressed: () {}, icon: const Icon(Icons.close))
        ],
      )),
    );

    return SizedBox(
      width: 300,
      child: Drawer(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: charList,
        ),
      ),
    );
  }
}
