// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class SymptomFieldsProvider extends ChangeNotifier {
  List<Widget> _autocompleteFields = [];
  List<TextEditingController> _textControllers = [];
  int _selectedSymptomIndex = 0;

  List<Widget> get autocompleteFields => _autocompleteFields;
  List<TextEditingController> get textControllers => _textControllers;
  int get selectedSymptomIndex => _selectedSymptomIndex;
  set selectedSymptomIndex(int index) {
    _selectedSymptomIndex = index;
    notifyListeners();
  }

  void addSymptomField(Widget field) {
    var textController = TextEditingController();
    _textControllers.add(textController);
    _autocompleteFields.add(field);
    notifyListeners();
  }

  void removeSymptomField(int index) {
    _autocompleteFields.removeAt(index);
    _textControllers.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
