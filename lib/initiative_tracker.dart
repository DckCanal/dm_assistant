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
    return const Material(
      color: Colors.black,
      child: Column(children: [
        Expanded(
          child: CharacterList(),
        ),
        InitiativeTrackerControlBar(),
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
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.separated(
            key: const PageStorageKey('InitiativeTrackerListView'),
            itemCount: characters.length,
            controller: appState.scrollController,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                height: 2,
              );
            },
            itemBuilder: (context, index) {
              return CharTile(
                character: characters[index],
                roundOwner: index == appState.currentTurn && appState.inCombat,
              );
            }),
      );
    });
  }
}
