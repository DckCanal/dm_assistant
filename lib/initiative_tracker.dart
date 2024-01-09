import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character.dart';
import 'initiative_tracker_control_bar.dart';
import 'app_state.dart';
import 'char_tile.dart';

class InitiativeTracker extends StatelessWidget {
  const InitiativeTracker({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Container(
      color: Colors.black,
      child: Column(children: [
        // const SizedBox(height: 20),
        // Text(appState.inCombat ? 'In combattimento' : 'Fuori combattimento'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Personaggi non attivi'),
            const SizedBox(width: 20),
            Switch(
                value: appState.showDisabledChar,
                onChanged: appState.setDisabledChar),
          ],
        ),
        const Expanded(
          child: CharacterList(),
        ),
        const InitiativeTrackerControlBar(),
      ]),
    );
  }
}

// class DisabledCharacterList extends StatelessWidget {
//   const DisabledCharacterList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<AppState>();
//     List<Widget> charList = appState.characters
//         .where(
//           (char) => !char.enabled,
//         )
//         .map((char) => SizedBox(
//               width: 280,
//               child: ListTile(
//                   title: Text(char.name),
//                   subtitle: Text('Iniziativa ${char.initiativeScore}'),

//                   onTap: () {
//                     appState.enableCharacter(char);
//                   }),
//             ))
//         .toList();

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeInExpo,
//       width: appState.characters.isNotEmpty ? 300 : 0,
//       child: ListView(
//         padding: const EdgeInsets.all(12),
//         children: charList,
//       ),
//     );
//   }
// }

// class DisabledCharacterDrawer extends StatelessWidget {
//   const DisabledCharacterDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<AppState>();
//     List<Widget> charList = appState.characters
//         .map((char) => ListTile(
//               title: Text(char.name),
//               subtitle: Text('Iniziativa ${char.initiativeScore}'),
//               onTap: () {
//                 appState.enableCharacter(char);
//               },
//             ))
//         .toList();

//     // Aggiungi il DrawerHeader come primo elemento della ListView
//     // TODO: fix bug!
//     charList.insert(
//       0,
//       DrawerHeader(
//           child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('Fuori combattimento'),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.close))
//         ],
//       )),
//     );

//     return SizedBox(
//       width: 300,
//       child: Drawer(
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.black,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: charList,
//         ),
//       ),
//     );
//   }
// }

class CharacterList extends StatelessWidget {
  const CharacterList({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Character> characters = appState.characters
        .where((char) => appState.showDisabledChar ? true : char.enabled)
        .toList();

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(12.0),
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.separated(
            key: const PageStorageKey('InitiativeTrackerListView'),
            itemCount: characters.length,
            controller: appState.scrollController,
            separatorBuilder: (BuildContext context, int index) {
              return //constraints.maxWidth > 600
                  //? const SizedBox(height: 10) :
                  Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                height: 14,
              );
            },
// child: AnimatedList(
            itemBuilder: (context, index) {
              return CharTile(
                character: characters[index],
                roundOwner: index == appState.currentTurn && appState.inCombat,
              );
            }
            // initialItemCount: characters.length,
            // itemBuilder: (context, index, animation) {
            //   return FadeTransition(
            //     opacity: Animation(),
            //     child: CharTile(
            //       character: characters[index],
            //       roundOwner: index == appState.currentTurn && appState.inCombat,
            //     ),
            //   );
            // },
            ),
      );
    });
  }
}
