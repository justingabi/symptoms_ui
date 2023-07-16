// medicine_provider.dart
import 'package:flutter/material.dart';
import 'medicine_model.dart';

class MedicineProvider with ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }
}
