import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character.dart';
import 'initiative_tracker_control_bar.dart';
import 'app_state.dart';
import 'char_tile.dart';

class InitiativeTracker extends StatelessWidget {
  const InitiativeTracker({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    //return Container(
    return Material(
      color: Colors.black,
      //decoration: BoxDecoration(color: Colors.black),
      child: Column(children: [
        // const SizedBox(height: 20),
        // Text(appState.inCombat ? 'In combattimento' : 'Fuori combattimento'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Personaggi non attivi'),
            const SizedBox(width: 20),
            Switch(
                value: appState.showDisabledChar,
                onChanged: appState.setDisabledChar),
          ],
        ),
        const Expanded(
          child: CharacterList(),
        ),
        const InitiativeTrackerControlBar(),
      ]),
    );
  }
}

class CharacterList extends StatelessWidget {
  const CharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Character> characters = appState.characters
        .where((char) => appState.showDisabledChar ? true : char.enabled)
        .toList();

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(12.0),
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.separated(
            key: const PageStorageKey('InitiativeTrackerListView'),
            itemCount: characters.length,
            controller: appState.scrollController,
            separatorBuilder: (BuildContext context, int index) {
              return //constraints.maxWidth > 600
                  //? const SizedBox(height: 10) :
                  Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                height: 2,
              );
            },
// child: AnimatedList(
            itemBuilder: (context, index) {
              return CharTile(
                character: characters[index],
                roundOwner: index == appState.currentTurn && appState.inCombat,
              );
            }
            // initialItemCount: characters.length,
            // itemBuilder: (context, index, animation) {
            //   return FadeTransition(
            //     opacity: Animation(),
            //     child: CharTile(
            //       character: characters[index],
            //       roundOwner: index == appState.currentTurn && appState.inCombat,
            //     ),
            //   );
            // },
            ),
      );
    });
  }
}
