import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/character_view.dart';
import 'package:dm_assistant/dice_roller.dart';
import 'package:dm_assistant/initiative_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'rect_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Builder(builder: (context) {
      return DefaultTabController(
        length: 3,
        initialIndex: 1,
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
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.flash_on_outlined)),
                Tab(icon: Icon(Icons.gamepad)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const CharacterView(),
              const InitiativeTracker(),
              DiceRoller(),
            ],
          ),
        ),
      );
    });
  }
}

class CampaignTitleDialog extends StatefulWidget {
  final String oldTitle;

  CampaignTitleDialog({required this.oldTitle, super.key});
  @override
  _CampaignTitleDialogState createState() => _CampaignTitleDialogState();
}

class _CampaignTitleDialogState extends State<CampaignTitleDialog> {
  String? newTitle;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                newTitle = value != '' ? value : widget.oldTitle;
              },
              onSubmitted: (value) {
                Navigator.of(context).pop(newTitle);
              },
              focusNode: focusNode,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 50),
            RectButton(
              primary: true,
              width: 125,
              onPressed: () {
                Navigator.of(context).pop(newTitle);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
