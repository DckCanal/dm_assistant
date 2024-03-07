import 'package:dm_assistant/character.dart';
import 'package:flutter/material.dart';
import 'app_state.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data.dart';

void main() async {
  await Hive.initFlutter();
  var characterBox = await Hive.openBox<Character>('characters');
  if (characterBox.isEmpty) {
    List<Character> defaultCharacters = getCharacters2();
    for (Character c in defaultCharacters) {
      characterBox.add(c);
    }
  }
  Hive.registerAdapter(CharacterAdapter());
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
            seedColor: appState.userColor, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
