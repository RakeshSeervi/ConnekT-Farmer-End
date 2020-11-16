import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SubCategoryDialog extends StatefulWidget {
  final List<String> items;

  SubCategoryDialog({@required this.items});

  List<String> getSuggestions(String query) {
    List<String> temp = [];
    temp.addAll(items);
    temp.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return temp;
  }

  @override
  _SubCategoryDialogState createState() => _SubCategoryDialogState();
}

class _SubCategoryDialogState extends State<SubCategoryDialog> {
  List result;
  TextEditingController category = TextEditingController();

  @override
  void initState() {
    result = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Select sub-category",
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 350,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderTextField(
                attribute: 'category',
                controller: category,
                decoration: InputDecoration(labelText: 'Search...'),
                onChanged: (value) {
                  setState(() {
                    result = widget.getSuggestions(value);
                  });
                },
              ),
            ),
            result.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
                      width: 400,
                      child: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(result[index]);
                              },
                              child: Text(result[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Text(
                    'No results found!',
                    style: TextStyle(color: Colors.red),
                  )
          ],
        ),
      ),
    );
  }
}
