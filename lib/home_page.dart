import 'dart:math';

import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/dice_roller.dart';
import 'package:dm_assistant/initiative_tracker.dart';
import 'package:dm_assistant/initiative_tracker_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'rect_button.dart';
import 'dice_roller.dart';

const maxWidth = 1000;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _currentTabIndexNotifier;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentTabIndexNotifier = ValueNotifier<int>(_tabController.index);
    _tabController.addListener(() {
      _currentTabIndexNotifier.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget? _createDrawer(context, constraints) {
    if (constraints.maxWidth >= maxWidth) {
      return null;
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: _currentTabIndexNotifier,
        builder: (context, currentTabIndex, child) {
          return Drawer(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: currentTabIndex == 0
                  ? const InitiativeTrackerNavigator(onDrawer: true)
                  : const SavedRollList());
        },
      );
    }
  }

  Widget createInitiativeTrackerBody(context, constraints) {
    return constraints.maxWidth < maxWidth
        ? const InitiativeTracker()
        : Row(
            children: [
              Container(
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                          right: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.onPrimary))),
                  child: const InitiativeTrackerNavigator(onDrawer: false)),
              const Expanded(child: InitiativeTracker()),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Builder(builder: (context) {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
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
                dividerColor: Theme.of(context).colorScheme.onPrimary,
                dividerHeight: 2,
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.flash_on_outlined)),
                  Tab(icon: Icon(Icons.gamepad)),
                ],
              ),
            ),
            drawer: _createDrawer(context, constraints),
            body: TabBarView(
              controller: _tabController,
              children: [
                createInitiativeTrackerBody(context, constraints),
                const DiceRoller(),
              ],
            ),
          );
        }),
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
