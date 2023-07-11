import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'symptom_fields_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SymptomFieldsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}
