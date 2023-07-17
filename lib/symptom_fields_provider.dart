import 'package:flutter/material.dart';

class SymptomFieldsProvider extends ChangeNotifier {
  List<Widget> _autocompleteFields = [];
  List<TextEditingController> _textControllers = [];
  List<String> _symptoms = [];

  List<Widget> get autocompleteFields => _autocompleteFields;
  List<TextEditingController> get textControllers => _textControllers;
  List<String> get symptoms => _symptoms;

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

  void addSymptom(String symptom) {
    _symptoms.add(symptom);
    notifyListeners();
  }

  void removeSymptom(String symptom) {
    _symptoms.add(symptom);
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
