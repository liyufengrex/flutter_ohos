import 'package:flutter/material.dart';
import 'package:home_module/home_module.dart';
import '';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HarmonyOS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter HarmonyOS'),
        ),
        body: const Center(
          child: HomePage(),
        ),
      ),
    );
  }
}