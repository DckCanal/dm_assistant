import 'package:dm_assistant/char_tile.dart';
import 'package:dm_assistant/character.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class ActiveCharacterList extends StatelessWidget {
  const ActiveCharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Character> characters = appState.characters;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.separated(
        key: const PageStorageKey('InitiativeTrackerListView'),
        itemCount: characters.length,
        controller: appState.scrollController,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          return CharTile(
            character: characters[index],
            onDelete: () {
              appState.removeCharacter(characters[index]);
            },
            onEnable: () {
              appState.enableCharacter(characters[index]);
            },
            onDisable: () {
              appState.disableCharacter(characters[index]);
            },
            onSetInitiativeScore: (int initiativeScore) {
              appState.setCharacterInitiativeScore(
                  characters[index], initiativeScore);
            },
            roundOwner: index == appState.currentTurn && appState.inCombat,
          );
        },
      ),
    );
  }
}
