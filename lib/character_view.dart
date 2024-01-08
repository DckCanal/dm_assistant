import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'character.dart';
import 'char_tile.dart';

enum CombatStatus { inCombat, outOfCombat }

class CharacterView extends StatefulWidget {
  const CharacterView({super.key});
  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  Set<CombatStatus> selection = <CombatStatus>{CombatStatus.outOfCombat};
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Character> characters = appState.characters.where((char) {
      if (!selection.contains(CombatStatus.outOfCombat)) {
        return char.enabled;
      } else if (!selection.contains(CombatStatus.inCombat)) {
        return !char.enabled;
      } else {
        return true;
      }
    }).toList();
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SegmentedButton<CombatStatus>(
            segments: const <ButtonSegment<CombatStatus>>[
              ButtonSegment<CombatStatus>(
                  value: CombatStatus.outOfCombat, label: Text('Non attivi')),
              ButtonSegment<CombatStatus>(
                  value: CombatStatus.inCombat, label: Text('In combattimento'))
            ],
            selected: selection,
            onSelectionChanged: (Set<CombatStatus> newSelection) {
              setState(() {
                selection = newSelection;
              });
            },
            multiSelectionEnabled: true,
          ),
          const SizedBox(height: 8),
          Expanded(child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.separated(
                key: const PageStorageKey('CharacterViewListView'),
                itemCount: characters.length,
                separatorBuilder: (BuildContext context, int index) {
                  return constraints.maxWidth > 600
                      ? const SizedBox(height: 10)
                      : Divider(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          height: 14,
                        );
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
                    roundOwner:
                        index == appState.currentTurn && appState.inCombat,
                  );
                },
              ),
            );
          }))
        ],
      ),
    );
  }
}
