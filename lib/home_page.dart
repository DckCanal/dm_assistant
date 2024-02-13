import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/character.dart';
// import 'package:dm_assistant/character_view.dart';
import 'package:dm_assistant/dice_roller.dart';
import 'package:dm_assistant/initiative_tracker.dart';
import 'package:dm_assistant/new_char_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'rect_button.dart';
import 'app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Builder(builder: (context) {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            ///elevation: 0,
            backgroundColor: Colors.black,
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
            //  backgroundColor: Colors.black,
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
                          child: BlockPicker(
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
            bottom: TabBar(
              // indicator: UnderlineTabIndicator(
              //   borderSide: BorderSide(color: Colors.red, width: 3),
              // ),
              dividerColor: Theme.of(context).colorScheme.onPrimary,
              dividerHeight: 2,
              tabs: const [
                //Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.flash_on_outlined)),
                Tab(icon: Icon(Icons.gamepad)),
              ],
            ),
          ),
          drawer: Drawer(
              backgroundColor: Colors
                  .black, // Theme.of(context).colorScheme.primaryContainer,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   side: BorderSide(
              //     color: Theme.of(context).colorScheme.inversePrimary,
              //     width: 1.0,
              //   ),
              // ),

              // shape: Border(
              //     right: BorderSide(
              //         width: 1,
              //         color: Theme.of(context).colorScheme.inversePrimary),
              //     top: BorderSide(
              //         width: 1,
              //         color: Theme.of(context).colorScheme.inversePrimary),
              //     bottom: BorderSide(
              //         width: 1,
              //         color: Theme.of(context).colorScheme.inversePrimary)),
              child: ListView(children: [
                ListTile(
                    trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
                ListTile(
                  leading: const Icon(Icons.group_add),
                  title: const Text("Nuovo personaggio"),
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await showDialog<Character>(
                      context: context,
                      builder: (context) {
                        return const NewCharDialog();
                      },
                    );
                    if (result != null) {
                      appState.addCharacter(result.name, result.initiativeBonus,
                          result.initiativeScore);
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("Personaggi non attivi"),
                  trailing: Switch(
                      value: appState.showDisabledChar,
                      onChanged: appState.setDisabledChar),
                )
              ])),
          body: const TabBarView(
            children: [
              //const CharacterView(),
              InitiativeTracker(),
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

  const CampaignTitleDialog({required this.oldTitle, super.key});
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
