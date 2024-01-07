import 'package:flutter/material.dart';
import 'app_state.dart';
import 'home_page.dart';
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
      home: const HomePage(),
    );
  }
}
