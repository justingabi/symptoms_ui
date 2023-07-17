// analyze_page.dart
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medicine_provider.dart';
import 'medicine_model.dart';

class AnalyzePage extends StatelessWidget {
  final String finalPrediction;

  AnalyzePage({required this.finalPrediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyze Page'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Diagnosis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Final Prediction: $finalPrediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Physician Order Entry',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Consumer<MedicineProvider>(
                  builder: (context, provider, child) {
                    if (provider.medicines.isEmpty) {
                      return Text('No Orders');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.medicines.length,
                        itemBuilder: (ctx, i) => Text(
                            provider.medicines[i].name ?? 'Unknown Medicine'),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.note_add),
                  onPressed: () => showDialog(
                      context: context, builder: (ctx) => AddMedicineDialog()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AddMedicineDialog extends StatefulWidget {
  @override
  _AddMedicineDialogState createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _medicines = <Medicine>[];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ..._medicines.map((e) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (_) {
                    setState(() {
                      _medicines.remove(e);
                    });
                  },
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.delete),
                    ),
                    onSaved: (value) => e.name = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a medicine';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
              ElevatedButton(
                child: Text('Add another medicine'),
                onPressed: () {
                  setState(() {
                    _medicines.add(Medicine());
                  });
                },
              ),
              ElevatedButton(
                child: Text('Accept'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<MedicineProvider>(context, listen: false)
                        .addMedicine(_medicines.last);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
