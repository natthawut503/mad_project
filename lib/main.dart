import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/gameProvider.dart';
// import 'package:account/screens/addcolorgame.dart';
// import 'package:account/screens/colorEditScreen.dart';
// import 'package:account/screens/colorplayscreen.dart';
import 'package:account/screens/gameSelection.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider()..initData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Training Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GameSelectionScreen(),  
    );
  }
}
