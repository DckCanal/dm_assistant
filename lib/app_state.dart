// import 'dart:js_util';

import 'package:dm_assistant/dice_roller.dart';
import 'package:flutter/material.dart';
import 'character.dart';
import 'dice.dart';
import 'data.dart';

//enum Page { initiativeTracker, diceRoller }

class AppState extends ChangeNotifier {
  //var page = Page.initiativeTracker;
  List<Character> characters = getCharacters();
  List<(RollFormula roll, String title)> savedRolls = getSavedRolls();
  List<RollHistoryEntry> rollHistory = getRolls();
  int currentTurn = 0;
  bool inCombat = false;
  final ScrollController scrollController = ScrollController();
  final Color defaultColor = const Color.fromARGB(255, 13, 0, 133);
  Color? userColor;
  String campaignTitle = 'Kraken bay';
  bool showDisabledChar = false;

  GlobalKey? animatedRollHistoryListKey;

  void setDisabledChar(bool newValue) {
    showDisabledChar = newValue;
    notifyListeners();
  }

  void setCampaignTitle(String newTitle) {
    campaignTitle = newTitle;
    notifyListeners();
  }

  void addSavedRoll(RollFormula rollFormula, String title) {
    if (!savedRolls.contains((rollFormula, title))) {
      savedRolls.add((rollFormula, title));
      notifyListeners();
    }
  }

  void removeSavedRoll(RollFormula rollFormula, String title) {
    if (savedRolls.contains((rollFormula, title))) {
      savedRolls.remove((rollFormula, title));
      notifyListeners();
    }
  }

  void addCharacter(String name, int initiativeBonus, [int? initiativeScore]) {
    characters.add(Character(initiativeBonus, name, initiativeScore));
    if (inCombat) {
      Character roundOwner = characters[currentTurn];
      _sortCharacters();
      currentTurn = characters.indexOf(roundOwner);
    }
    notifyListeners();
  }

  void removeCharacter(Character character) {
    int index = characters.indexOf(character);
    if (index < currentTurn) {
      currentTurn--;
    } else if (index == currentTurn && currentTurn == characters.length - 1) {
      currentTurn = 0;
    }
    characters.remove(character);
    notifyListeners();
  }

  void enableCharacter(Character character) {
    character.enabled = true;
    if (inCombat) {
      Character roundOwner = characters[currentTurn];
      _sortCharacters();
      currentTurn = characters.indexOf(roundOwner);
    }
    notifyListeners();
  }

  void disableCharacter(Character character) {
    int index = characters.indexOf(character);
    if (index < currentTurn) {
      currentTurn--;
    } else if (index == currentTurn && currentTurn == characters.length - 1) {
      currentTurn = 0;
    }
    character.enabled = false;
    _sortCharacters();
    notifyListeners();
  }

  void setRoundOwner(Character character) {
    int newTurnIndex = characters.indexOf(character);
    if (newTurnIndex != -1) {
      currentTurn = newTurnIndex;
      notifyListeners();
    }
  }

  void setCharacterInitiativeScore(Character character, int initiativeScore) {
    character.initiativeScore = initiativeScore;
    if (inCombat) {
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
    if (inCombat) {
      if (characters.every((element) => element.enabled == false)) {
        endCombat();
      } else {
        currentTurn = (currentTurn + 1) % characters.length;
        if (characters[currentTurn].enabled == false) {
          nextTurnOrStartCombat();
        } else {
          scrollController.animateTo(
            currentTurn * 82,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    } else {
      _sortCharacters();
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      inCombat = true;
    }
    notifyListeners();
  }

  void endCombat() {
    inCombat = false;
    currentTurn = 0;
    notifyListeners();
  }

  void rerollInitiative() {
    for (Character character in characters) {
      character.rollInitiative();
    }
    if (inCombat) {
      _sortCharacters();
    }
    notifyListeners();
  }

  void changeColor(Color color) {
    userColor = color;
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
          99, (context, animation) => RollTile(roll: removedItem));
    }
    animatedList?.insertItem(0);
    notifyListeners();
  }
}
