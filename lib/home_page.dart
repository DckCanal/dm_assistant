import 'package:dm_assistant/app_state.dart';
import 'package:dm_assistant/character.dart';
import 'package:dm_assistant/dice_roller.dart';
import 'package:dm_assistant/initiative_tracker.dart';
import 'package:dm_assistant/settings_drawer.dart';
import 'package:dm_assistant/new_char_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    //if (constraints.maxWidth >= maxWidth) {
    //  return null;
    //} else {
    return ValueListenableBuilder<int>(
      valueListenable: _currentTabIndexNotifier,
      builder: (context, currentTabIndex, child) {
        return Drawer(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: const SettingsDrawer(onDrawer: true));
      },
    );
    //}
  }

  Widget? _createFAB({onResult}) {
    return ValueListenableBuilder<int>(
        valueListenable: _currentTabIndexNotifier,
        builder: (context, currentTabIndex, child) {
          if (currentTabIndex != 0) {
            return Container();
          } else {
            return LayoutBuilder(builder: (context, constraints) {
              double screenHeight = MediaQuery.of(context).size.height;
              double maxWidth = constraints.maxWidth;
              bool checkConstraint() => maxWidth >= 600 && screenHeight >= 800;
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: checkConstraint() ? 150 : 110, horizontal: 0),
                child: FloatingActionButton(
                    onPressed: () async {
                      final result = await showDialog<Character>(
                        context: context,
                        builder: (context) {
                          return const NewCharDialog();
                        },
                      );
                      if (result != null) {
                        onResult(result);
                      }
                    },
                    child: const Icon(Icons.group_add)),
              );
            });
          }
        });
  }

  Widget createInitiativeTrackerBody(context, constraints) {
    // return constraints.maxWidth < maxWidth
    //     ? const InitiativeTracker()
    //     : Row(
    //         children: [
    //           Container(
    //               width: 300,
    //               decoration: BoxDecoration(
    //                   color: Colors.black,
    //                   border: Border(
    //                       right: BorderSide(
    //                           width: 1,
    //                           color: Theme.of(context).colorScheme.onPrimary))),
    //               child: const InitiativeTrackerNavigator(onDrawer: false)),
    //           const Expanded(child: InitiativeTracker()),
    //         ],
    //       );
    return const InitiativeTracker();
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
              backgroundColor: Colors.black,
              title: TextButton(
                  onPressed: () async {
                    final result = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          return CampaignTitleDialog(
                            campaigns: appState.campaigns,
                          );
                        });
                    if (result != null) {
                      appState.changeCampaign(result);
                    }
                  },
                  child: Text(appState.campaignTitle)),
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
            floatingActionButton: _createFAB(onResult: (result) {
              appState.addCharacter(
                  result.name, result.initiativeBonus, result.initiativeScore);
            }),
          );
        }),
      );
    });
  }
}

class CampaignTitleDialog extends StatefulWidget {
  final List<Campaign> campaigns;

  const CampaignTitleDialog({required this.campaigns, super.key});
  @override
  _CampaignTitleDialogState createState() => _CampaignTitleDialogState();
}

class _CampaignTitleDialogState extends State<CampaignTitleDialog> {
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
        child: ListView(
          children: [
            for (Campaign c in widget.campaigns)
              TextButton(
                child: Text(c.title),
                onPressed: () =>
                    {Navigator.of(context).pop(widget.campaigns.indexOf(c))},
              ),
          ],
        ),
      ),
    );
  }
}
