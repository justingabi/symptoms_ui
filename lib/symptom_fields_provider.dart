// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class SymptomFieldsProvider extends ChangeNotifier {
  List<Widget> _autocompleteFields = [];

  List<Widget> get autocompleteFields => _autocompleteFields;

  void addSymptomField(Widget field) {
    _autocompleteFields.add(field);
    notifyListeners();
  }

  void removeSymptomField(int index) {
    _autocompleteFields.removeAt(index);
    notifyListeners();
  }
}
