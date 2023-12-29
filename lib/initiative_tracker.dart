import 'package:flutter/material.dart';
import 'round_button.dart';
import 'rect_button.dart';
import 'character.dart';
import 'char_tile.dart';

class InitiativeTracker extends StatelessWidget {
  final List<Character> characters;
  final int currentTurn;
  final bool inCombat;
  final ScrollController scrollController;
  final void Function(String name, int initiativeBonus, [int? initiativeScore])
      onAddCharacter;
  final void Function(Character character) onRemoveCharacter,
      onEnableCharacter,
      onDisableCharacter;
  final void Function(Character character, int initiativeScore)
      onSetCharacterInitiativeScore;
  final VoidCallback onSortCharacters,
      onNextTurnOrStartCombat,
      onEndCombat,
      onRerollInitiative;

  const InitiativeTracker({
    required this.characters,
    required this.currentTurn,
    required this.inCombat,
    required this.scrollController,
    required this.onAddCharacter,
    required this.onRemoveCharacter,
    required this.onEnableCharacter,
    required this.onDisableCharacter,
    required this.onSetCharacterInitiativeScore,
    required this.onSortCharacters,
    required this.onNextTurnOrStartCombat,
    required this.onEndCombat,
    required this.onRerollInitiative,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              key: const PageStorageKey('InitiativeTrackerListView'),
              itemCount: characters.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return CharTile(
                  character: characters[index],
                  onDelete: () {
                    onRemoveCharacter(characters[index]);
                  },
                  onEnable: () {
                    onEnableCharacter(characters[index]);
                  },
                  onDisable: () {
                    onDisableCharacter(characters[index]);
                  },
                  onSetInitiativeScore: (int initiativeScore) {
                    onSetCharacterInitiativeScore(
                        characters[index], initiativeScore);
                  },
                  roundOwner: index == currentTurn && inCombat,
                );
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                  top: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.onPrimary))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundButton(
                  primary: false,
                  icon: const Icon(Icons.group_add),
                  radius: 90,
                  onPressed: () async {
                    final result = await showDialog<Character>(
                      context: context,
                      builder: (context) {
                        String name = '';
                        int initiativeBonus = 0;
                        int? initiativeScore;
                        return Dialog(
                          child: Container(
                            width: 500,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Nuovo personaggio',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(
                                            labelText: 'Nome'),
                                        onChanged: (value) {
                                          name = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                            labelText: 'Bonus di iniziativa'),
                                        onChanged: (value) {
                                          initiativeBonus =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                            labelText:
                                                'Punteggio di iniziativa (opzionale)'),
                                        onChanged: (value) {
                                          initiativeScore = int.tryParse(value);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RectButton(
                                      primary: false,
                                      width: 125,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Annulla',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    RectButton(
                                      primary: true,
                                      width: 125,
                                      onPressed: () {
                                        Navigator.of(context).pop(Character(
                                            initiativeBonus,
                                            name,
                                            initiativeScore));
                                      },
                                      child: const Text('Aggiungi'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    if (result != null) {
                      onAddCharacter(result.name, result.initiativeBonus,
                          result.initiativeScore);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RectButton(
                      onPressed: onSortCharacters,
                      primary: false,
                      height: 60,
                      width: 85,
                      icon: const Icon(
                        Icons.import_export,
                        color: Colors.white,
                        size: 36,
                        semanticLabel: 'Riordina in base all\'iniziativa',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RoundButton(
                        onPressed: onNextTurnOrStartCombat,
                        primary: true,
                        radius: 110,
                        icon: Icon(
                          inCombat ? Icons.arrow_forward : Icons.double_arrow,
                          color: Colors.white,
                          size: 54,
                          semanticLabel: (inCombat
                              ? 'Avanza al prossimo round'
                              : 'Inizia combattimento'),
                        ),
                      ),
                    ),
                    RectButton(
                      onPressed: inCombat ? onEndCombat : null,
                      height: 60,
                      width: 85,
                      primary: false,
                      icon: const Icon(
                        Icons.crop_square,
                        color: Colors.white,
                        size: 36,
                        semanticLabel: 'Esci dal combattimento',
                      ),
                    )
                  ],
                ),
                RoundButton(
                  primary: false,
                  icon: const Icon(
                    Icons.cyclone,
                    size: 40,
                    semanticLabel: "Ritira tutte le iniziative",
                  ),
                  radius: 90,
                  onPressed: !inCombat ? onRerollInitiative : null,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
