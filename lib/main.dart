import 'package:flutter/material.dart';
import 'app_state.dart';
import 'campaign_title_dialog.dart';
import 'initiative_tracker.dart';
import 'dice_roller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MainComponent(),
    );
  }
}

class MainComponent extends StatelessWidget {
  const MainComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return MaterialApp(
      title: 'DM Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: appState.userColor ?? appState.defaultColor,
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: TextButton(
                  onPressed: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          return CampaignTitleDialog(
                            oldTitle: appState.campaignTitle,
                          );
                        });
                    if (result != null) {
                      appState.setCampaignTitle(result);
                    }
                  },
                  child: Text(appState.campaignTitle)),
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
                            child: ColorPicker(
                              pickerColor:
                                  appState.userColor ?? appState.defaultColor,
                              onColorChanged: appState.changeColor,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                      icon: Icon(
                          Icons.flash_on_outlined)), //Icons.directions_car,
                  Tab(icon: Icon(Icons.gamepad)), // Icons.directions_transit
                ],
              ),
            ),
            body: TabBarView(
              children: [
                const InitiativeTracker(),
                DiceRoller(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
