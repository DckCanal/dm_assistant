// import 'dart:js_util';

import 'package:dm_assistant/dice_roller.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'character.dart';
import 'dice.dart';
import 'data.dart';

//enum Page { initiativeTracker, diceRoller }

class Campaign {
  // Game data
  List<Character> characters;
  // List<(RollFormula roll, String title)> savedRolls;
  List<SavedRoll> savedRolls;
  List<RollHistoryEntry> rollHistory;
  String title;

  // Settings
  Color color;
  bool showDisabledChar = false;
  bool inCombat;
  int currentTurn;

  Campaign(
      {required this.title,
      required this.characters,
      required this.savedRolls,
      required this.rollHistory,
      this.color = const Color.fromARGB(255, 13, 0, 133),
      this.showDisabledChar = false,
      this.inCombat = false,
      this.currentTurn = 0});
}

class AppState extends ChangeNotifier {
  final List<Campaign> _campaigns = [
    Campaign(
        characters: getCharacters(),
        savedRolls: getSavedRolls(),
        rollHistory: getRolls(),
        title: "Kraken bay"),
    Campaign(
        characters: getCharacters2(),
        savedRolls: getSavedRolls2(),
        rollHistory: getRolls2(),
        title: "Malvagi")
  ];
  int _campaignIndex = 0;
  Campaign get _c => _campaigns[_campaignIndex];

  List<Character> get characters => _c.characters;
  //List<(RollFormula roll, String title)> get savedRolls => _c.savedRolls;
  List<SavedRoll> get savedRolls => _c.savedRolls;
  List<RollHistoryEntry> get rollHistory => _c.rollHistory;
  String get campaignTitle => _c.title;
  Color get userColor => _c.color;

  int get currentTurn => _c.currentTurn;
  bool get inCombat => _c.inCombat;
  bool get showDisabledChar => _c.showDisabledChar;

  ScrollController scrollController = ScrollController();
  GlobalKey? animatedRollHistoryListKey;
  GlobalKey? animatedSavedRollListKey;

  List<Campaign> get campaigns => _campaigns;

  void changeCampaign(int newCampaignIndex) {
    _campaignIndex = newCampaignIndex;
    scrollController = ScrollController();
    var animatedRollHistoryList =
        animatedRollHistoryListKey?.currentState as AnimatedListState?;
    animatedRollHistoryList
        ?.removeAllItems((context, animation) => Container());
    animatedRollHistoryList?.insertAllItems(
        0, _campaigns[newCampaignIndex].rollHistory.length);
    var animatedSavedRollList =
        animatedSavedRollListKey?.currentState as AnimatedListState?;
    animatedSavedRollList?.removeAllItems((context, animation) => Container());
    animatedSavedRollList?.insertAllItems(
        0, _campaigns[newCampaignIndex].savedRolls.length);
    notifyListeners();
  }

  void setDisabledChar(bool newValue) {
    _c.showDisabledChar = newValue;
    notifyListeners();
  }

  void setCampaignTitle(String newTitle) {
    _c.title = newTitle;
    notifyListeners();
  }

  void addSavedRoll(SavedRoll newSavedRoll) {
    if (!savedRolls.contains(newSavedRoll)) {
      savedRolls.add(newSavedRoll);
      var animatedList =
          animatedSavedRollListKey?.currentState as AnimatedListState?;
      animatedList?.insertItem(0);
      notifyListeners();
    }
  }

  void removeSavedRoll(SavedRoll savedRoll) {
    if (savedRolls.contains(savedRoll)) {
      int index = savedRolls.indexOf(savedRoll);
      savedRolls.remove(savedRoll);
      var animatedList =
          animatedSavedRollListKey?.currentState as AnimatedListState?;
      animatedList?.removeItem(
          index,
          (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: SavedRollTile(
                  savedRoll: savedRoll,
                ),
              ));
      notifyListeners();
    }
  }

  void addCharacter(String name, int initiativeBonus, [int? initiativeScore]) {
    characters.add(Character(initiativeBonus, name, initiativeScore));
    if (_c.inCombat) {
      Character roundOwner = characters[_c.currentTurn];
      _sortCharacters();
      _c.currentTurn = characters.indexOf(roundOwner);
    }
    notifyListeners();
  }

  void removeCharacter(Character character) {
    int index = characters.indexOf(character);
    if (index < _c.currentTurn) {
      _c.currentTurn--;
    } else if (index == _c.currentTurn &&
        _c.currentTurn == characters.length - 1) {
      _c.currentTurn = 0;
    }
    characters.remove(character);
    notifyListeners();
  }

  void enableCharacter(Character character) {
    character.enabled = true;
    if (_c.inCombat) {
      Character roundOwner = characters[_c.currentTurn];
      _sortCharacters();
      _c.currentTurn = characters.indexOf(roundOwner);
    }
    notifyListeners();
  }

  void disableCharacter(Character character) {
    int index = characters.indexOf(character);
    if (index < _c.currentTurn) {
      _c.currentTurn--;
    } else if (index == _c.currentTurn &&
        _c.currentTurn == characters.length - 1) {
      _c.currentTurn = 0;
    }
    character.enabled = false;
    _sortCharacters();
    notifyListeners();
  }

  void setRoundOwner(Character character) {
    int newTurnIndex = characters.indexOf(character);
    if (newTurnIndex != -1) {
      _c.currentTurn = newTurnIndex;
      notifyListeners();
    }
  }

  void setCharacterInitiativeScore(Character character, int initiativeScore) {
    character.initiativeScore = initiativeScore;
    if (_c.inCombat) {
      _sortCharacters();
    }
    notifyListeners();
  }

  void _sortCharacters() {
    // private method, to be call by other methods BEFORE notifyListeners()
    characters.sort((a, b) {
      if (a.enabled && !b.enabled) {
        return -1;
      } else if (!a.enabled && b.enabled) {
        return 1;
      } else {
        return (b.initiativeScore ?? 0).compareTo(a.initiativeScore ?? 0);
      }
    });
  }

  void sortCharacters() {
    _sortCharacters();
    notifyListeners();
  }

  void nextTurnOrStartCombat() {
    if (_c.inCombat) {
      if (characters.every((element) => element.enabled == false)) {
        endCombat();
      } else {
        _c.currentTurn = (_c.currentTurn + 1) % characters.length;
        if (characters[_c.currentTurn].enabled == false) {
          nextTurnOrStartCombat();
        } else {
          scrollController.animateTo(
            _c.currentTurn * 82,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    } else {
      WakelockPlus.enable();
      _sortCharacters();
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _c.inCombat = true;
    }
    notifyListeners();
  }

  void endCombat() {
    _c.inCombat = false;
    _c.currentTurn = 0;

    WakelockPlus.disable();
    notifyListeners();
  }

  void rerollInitiative() {
    for (Character character in characters) {
      character.rollInitiative();
    }
    if (_c.inCombat) {
      _sortCharacters();
    }
    notifyListeners();
  }

  void changeColor(Color color) {
    _c.color = color;
    notifyListeners();
  }

  void addRollHistoryEntry(RollHistoryEntry entry) {
    rollHistory.insert(0, entry);

    var animatedList =
        animatedRollHistoryListKey?.currentState as AnimatedListState?;
    // Controlla se la lista supera la dimensione massima (100 elementi)
    if (rollHistory.length > 100) {
      // Rimuovi il tiro di dado più vecchio
      RollHistoryEntry removedItem = rollHistory.removeAt(100);
      animatedList?.removeItem(
          99,
          (context, animation) => SizeTransition(
              sizeFactor: animation, child: RollTile(roll: removedItem)));
    }
    animatedList?.insertItem(0);
    notifyListeners();
  }
}
