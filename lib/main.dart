import 'package:flutter/material.dart';
import 'character.dart';
import 'data.dart';
import 'campaign_title_dialog.dart';
import 'initiative_tracker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Character> characters = getCharacters();
  int currentTurn = 0;
  bool inCombat = false;
  final ScrollController _scrollController = ScrollController();
  final Color defaultColor = const Color.fromARGB(255, 13, 0, 133);
  Color? userColor;
  String campaignTitle = 'Nuova campagna';
  String? saveFilePath;
  bool isModified = false;

  // Future<void> saveState() async {
  //   if (saveFilePath == null) {
  //     FilePickerResult? result = await FilePicker.platform.saveFile(
  //       dialogTitle: 'Scegli un file per salvare',
  //       type: FileType.custom,
  //       allowedExtensions: ['dma'],
  //     );
  //     if (result != null) {
  //       saveFilePath = result.files.single.path;
  //     } else {
  //       return;
  //     }
  //   }
  //   final file = File(saveFilePath!);
  //   final stateData = jsonEncode({
  //     'characters': characters.map((c) => c.toJson()).toList(),
  //     'currentTurn': currentTurn,
  //     'inCombat': inCombat,
  //   });
  //   await file.writeAsString(stateData);
  //   setState(() {
  //     isModified = false;
  //   });
  // }

  void _setCampaignTitle(String newTitle) {
    setState(() {
      campaignTitle = newTitle;
    });
  }

  void _addCharacter(String name, int initiativeBonus, [int? initiativeScore]) {
    setState(() {
      characters.add(Character(initiativeBonus, name, initiativeScore));
    });
  }

  void _removeCharacter(Character character) {
    setState(() {
      int index = characters.indexOf(character);
      if (index < currentTurn) {
        currentTurn--;
      } else if (index == currentTurn && currentTurn == characters.length - 1) {
        currentTurn = 0;
      }
      characters.remove(character);
    });
  }

  void _enableCharacter(Character character) {
    setState(() {
      character.enabled = true;
    });
  }

  void _disableCharacter(Character character) {
    setState(() {
      character.enabled = false;
    });
  }

  void _setCharacterInitiativeScore(Character character, int initiativeScore) {
    setState(() {
      character.initiativeScore = initiativeScore;
    });
  }

  void _sortCharacters() {
    setState(() {
      characters.sort((a, b) {
        if (a.enabled && !b.enabled) {
          return -1;
        } else if (!a.enabled && b.enabled) {
          return 1;
        } else {
          return (b.initiativeScore ?? 0).compareTo(a.initiativeScore ?? 0);
        }
      });
    });
  }

  void _nextTurnOrStartCombat() {
    setState(() {
      if (inCombat) {
        if (characters.every((element) => element.enabled == false)) {
          _endCombat();
        } else {
          currentTurn = (currentTurn + 1) % characters.length;
          if (characters[currentTurn].enabled == false) {
            _nextTurnOrStartCombat();
          } else {
            _scrollController.animateTo(
              currentTurn *
                  104, // Sostituisci con l'altezza del tuo widget CharTile.
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      } else {
        _sortCharacters();
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        inCombat = true;
      }
    });
  }

  void _endCombat() {
    setState(() {
      inCombat = false;
      currentTurn = 0;
    });
  }

  void _rerollInitiative() {
    setState(() {
      for (Character character in characters) {
        character.rollInitiative();
      }
      _sortCharacters();
    });
  }

  void _changeColor(Color color) {
    setState(() {
      userColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DM Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: userColor ?? defaultColor, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: TextButton(
                  //primary: false,
                  onPressed: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          return CampaignTitleDialog(
                            oldTitle: campaignTitle,
                          );
                        });
                    if (result != null) {
                      _setCampaignTitle(result);
                    }
                  },
                  child: Text(campaignTitle)),
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Scegli un colore'),
                          content: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: userColor ?? defaultColor,
                              onColorChanged: _changeColor,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    // Aggiungi il tuo codice qui per salvare un file.
                  },
                ),
                IconButton(
                  icon: Icon(Icons.folder_open),
                  onPressed: () {
                    // Aggiungi il tuo codice qui per aprire un file.
                  },
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                InitiativeTracker(
                  characters: characters,
                  currentTurn: currentTurn,
                  inCombat: inCombat,
                  scrollController: _scrollController,
                  onAddCharacter: _addCharacter,
                  onRemoveCharacter: _removeCharacter,
                  onEnableCharacter: _enableCharacter,
                  onDisableCharacter: _disableCharacter,
                  onSetCharacterInitiativeScore: _setCharacterInitiativeScore,
                  onSortCharacters: _sortCharacters,
                  onNextTurnOrStartCombat: _nextTurnOrStartCombat,
                  onEndCombat: _endCombat,
                  onRerollInitiative: _rerollInitiative,
                ),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
          ),
        );
      }),
    );
  }
}
