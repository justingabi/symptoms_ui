import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'symptom_fields_provider.dart';
import 'models.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var symptomFieldsProvider = Provider.of<SymptomFieldsProvider>(context);
    List<Widget> _autocompleteFields = symptomFieldsProvider.autocompleteFields;

    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Symptoms',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ..._autocompleteFields,
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      symptomFieldsProvider.addSymptomField(
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return listItems.where((String item) {
                                    return item.contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selectedItem) {
                                  print('Selected item: $selectedItem');
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                symptomFieldsProvider.removeSymptomField(
                                    _autocompleteFields.length - 1);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Add symptom'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
