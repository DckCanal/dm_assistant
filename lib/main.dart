import 'package:flutter/material.dart';
import 'round_button.dart';
import 'rect_button.dart';
import 'character.dart';
import 'data.dart';
import 'char_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DM Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 13, 0, 133),
            brightness: Brightness.dark),
        //background: const Color.fromARGB(255, 3, 0, 19),
        //outline: const Color.fromARGB(255, 47, 80, 255), //030013
        //primaryContainer: const Color.fromARGB(255, 24, 6, 114)),
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Color.fromARGB(255, 3, 0, 19),
        // ),
        // bottomAppBarTheme:
        //     const BottomAppBarTheme(color: Color.fromARGB(255, 3, 0, 19)),
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //     backgroundColor: Color.fromARGB(255, 3, 0, 19)),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              InitiativeTracker(title: 'Flutter Demo Home Page'),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class InitiativeTracker extends StatefulWidget {
  const InitiativeTracker({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<InitiativeTracker> createState() => _InitiativeTrackerState();
}

class _InitiativeTrackerState extends State<InitiativeTracker> {
  List<Character> characters = getCharacters();
  int currentTurn = 0;
  bool inCombat = false;

  void _addCharacter(String name, int initiativeBonus, [int? initiativeScore]) {
    setState(() {
      characters.add(Character(initiativeBonus, name, initiativeScore));
      // if (inCombat) {
      //   _sortCharacters();
      // }
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

  void _sortCharacters() {
    setState(() {
      characters.sort(
          (a, b) => (b.initiativeScore ?? 0).compareTo(a.initiativeScore ?? 0));
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
          }
        }
      } else {
        // for (Character character in characters) {
        //   character.rollInitiative();
        // }
        //characters.sort((a, b) => b.initiativeRoll.compareTo(a.initiativeRoll));
        _sortCharacters();
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
      // characters
      //     .sort((a, b) => b.initiativeScore?.compareTo(a.initiativeScore));
      _sortCharacters();
    });
  }

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                return CharTile(
                  character: characters[index],
                  onDelete: () {
                    _removeCharacter(characters[index]);
                  },
                  onEnable: () {
                    _enableCharacter(characters[index]);
                  },
                  onDisable: () {
                    _disableCharacter(characters[index]);
                  },
                  roundOwner: index == currentTurn && inCombat,
                );
                // return Card(
                //   color:
                //       index == currentTurn && inCombat ? Colors.yellow : null,
                //   child: ListTile(
                //     title: Text(characters[index].name),
                //     subtitle: Text(
                //         'Iniziativa: ${characters[index].initiativeScore}'),
                //     trailing: IconButton(
                //       icon: const Icon(Icons.delete_forever),
                //       onPressed: () => _removeCharacter(characters[index]),
                //     ),
                //   ),
                // );
              },
            ),
          ),
          // child: Column(
          //   // Column is also a layout widget. It takes a list of children and
          //   // arranges them vertically. By default, it sizes itself to fit its
          //   // children horizontally, and tries to be as tall as its parent.
          //   //
          //   // Column has various properties to control how it sizes itself and
          //   // how it positions its children. Here we use mainAxisAlignment to
          //   // center the children vertically; the main axis here is the vertical
          //   // axis because Columns are vertical (the cross axis would be
          //   // horizontal).
          //   //
          //   // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          //   // action in the IDE, or press "p" in the console), to see the
          //   // wireframe for each widget.
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     const Text(
          //       'You have pushed the button this many times:',
          //     ),
          //     Text(
          //       '$_counter',
          //       style: Theme.of(context).textTheme.headlineMedium,
          //     ),
          //   ],
          // ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                  top: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.onPrimary))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundButton(
                primary: false,
                icon: const Icon(Icons.group_add),
                radius: 90,
                onPressed: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RectButton(
                    onPressed: _sortCharacters,
                    primary: false,
                    height: 60,
                    width: 85,
                    icon: const Icon(
                      Icons.import_export,
                      color: Colors.white,
                      size: 36,
                      semanticLabel: 'Riordina in base all\'iniziativa',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: RoundButton(
                      onPressed: _nextTurnOrStartCombat,
                      primary: true,
                      radius: 110,
                      icon: Icon(
                        inCombat ? Icons.arrow_forward : Icons.double_arrow,
                        color: Colors.white,
                        size: 54,
                        semanticLabel: (inCombat
                            ? 'Avanza al prossimo round'
                            : 'Inizia combattimento'),
                      ),
                    ),
                  ),
                  RectButton(
                    onPressed: inCombat ? _endCombat : null,
                    height: 60,
                    width: 85,
                    primary: false,
                    icon: const Icon(
                      Icons.crop_square,
                      color: Colors.white,
                      size: 36,
                      semanticLabel: 'Esci dal combattimento',
                    ),
                  )
                ],
              ),
              RoundButton(
                primary: false,
                icon: const Icon(
                  Icons.cyclone,
                  size: 40,
                  semanticLabel: "Ritira tutte le iniziative",
                ),
                radius: 90,
                onPressed: !inCombat ? _rerollInitiative : null,
              ),
            ],
          ),
        ),
      ]),
    );

    // return Scaffold(
    //   backgroundColor: Colors.black,
    //   bottomNavigationBar: BottomAppBar(
    //     padding: EdgeInsets.zero,
    //     height: 162,
    //     child: Container(
    //       decoration: BoxDecoration(
    //           color: Colors.black,
    //           border: Border(
    //               top: BorderSide(
    //                   width: 1,
    //                   color: Theme.of(context).colorScheme.onPrimary))),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           RectButton(
    //             onPressed: () {},
    //             primary: false,
    //             height: 60,
    //             width: 85,
    //             icon: const Icon(
    //               Icons.import_export,
    //               color: Colors.white,
    //               size: 36,
    //               semanticLabel: 'Riordina in base all\'iniziativa',
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(25.0),
    //             child: RoundButton(
    //               onPressed: () {},
    //               primary: true,
    //               radius: 110,
    //               icon: const Icon(
    //                 Icons.double_arrow,
    //                 color: Colors.white,
    //                 size: 54,
    //                 semanticLabel: 'Avanza al prossimo round',
    //               ),
    //             ),
    //           ),
    //           RectButton(
    //             onPressed: () {},
    //             height: 60,
    //             width: 85,
    //             primary: false,
    //             icon: const Icon(
    //               Icons.crop_square,
    //               color: Colors.white,
    //               size: 36,
    //               semanticLabel: 'Esci dal combattimento',
    //             ),
    //           )
    //         ],
    //       ),
    //     ),

    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     //title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       //
    //       // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
    //       // action in the IDE, or press "p" in the console), to see the
    //       // wireframe for each widget.
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headlineMedium,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}
