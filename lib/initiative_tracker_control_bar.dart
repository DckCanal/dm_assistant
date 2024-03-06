import 'package:dm_assistant/rect_button.dart';
import 'package:dm_assistant/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class InitiativeTrackerControlBar extends StatelessWidget {
  const InitiativeTrackerControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    double rectBigWidth = 80,
        rectBigHeight = 65,
        rectSmallWidth = 60,
        rectSmallHeight = 48,
        rectIconBigSize = 36,
        rectIconSmallSize = 24,
        primaryRoundIconBigSize = 54,
        primaryRoundIconSmallSize = 40,
        secondaryRoundIconBigSize = 40,
        secondaryRoundIconSmallSize = 23,
        primaryRoundBigRadius = 110,
        primaryRoundSmallRadius = 70,
        secondaryRoundBigRadius = 90,
        secondaryRoundSmallRadius = 54;

    double screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      bool checkConstraint() => maxWidth >= 600 && screenHeight >= 800;
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RectButton(
                onPressed: appState.sortCharacters,
                primary: false,
                height: checkConstraint() ? rectBigHeight : rectSmallHeight,
                width: checkConstraint() ? rectBigWidth : rectSmallWidth,
                icon: Icon(
                  Icons.import_export,
                  color: Colors.white,
                  size: checkConstraint() ? rectIconBigSize : rectIconSmallSize,
                  semanticLabel: 'Riordina in base all\'iniziativa',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RoundButton(
                  onPressed: appState.nextTurnOrStartCombat,
                  primary: true,
                  radius: checkConstraint()
                      ? primaryRoundBigRadius
                      : primaryRoundSmallRadius,
                  icon: Icon(
                    appState.inCombat
                        ? Icons.arrow_forward
                        : Icons.double_arrow,
                    color: Colors.white,
                    size: checkConstraint()
                        ? primaryRoundIconBigSize
                        : primaryRoundIconSmallSize,
                    semanticLabel: (appState.inCombat
                        ? 'Avanza al prossimo round'
                        : 'Inizia combattimento'),
                  ),
                ),
              ),
              RoundButton(
                primary: false,
                icon: Icon(
                  !appState.inCombat ? Icons.cyclone : Icons.crop_square,
                  size: checkConstraint()
                      ? secondaryRoundIconBigSize
                      : secondaryRoundIconSmallSize,
                  semanticLabel: !appState.inCombat
                      ? "Ritira tutte le iniziative"
                      : "Esci dal combattimento",
                ),
                radius: checkConstraint()
                    ? secondaryRoundBigRadius
                    : secondaryRoundSmallRadius,
                onPressed: !appState.inCombat
                    ? appState.rerollInitiative
                    : appState.endCombat,
              ),
            ],
          ),
        ),
      );
    });
  }
}
