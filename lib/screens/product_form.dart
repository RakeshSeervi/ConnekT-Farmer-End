import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  var storage = FirebaseStorage.instance;
  var firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  Uuid uuid = Uuid();

  TextEditingController productName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List<DropdownMenuItem> category = [
    DropdownMenuItem(
      value: 'Fruits',
      child: Text(
        'Fruits',
        style: TextStyle(color: Colors.black54),
      ),
    ),
    DropdownMenuItem(
      value: 'Vegetables',
      child: Text(
        'Vegetables',
        style: TextStyle(color: Colors.black54),
      ),
    ),
  ];
  String selectedCategory = 'Fruits';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a product"),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: _image != null
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Center(child: Text('Product image preview')),
                          ),
                          FloatingActionButton(
                            onPressed: getImage,
                            tooltip: 'Pick Image',
                            child: Icon(Icons.photo),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: productName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product name'),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Product name cannot be empty!";
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: price,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Price',
                            prefix: Text('Rs ')),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (num.tryParse(value) == 0 || value.isEmpty)
                            return 'Product price cannot be zero!';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        minLines: 3,
                        maxLines: 10,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Description cannot be empty!";
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Category:  ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      iconEnabledColor: Colors.grey,
                                      value: selectedCategory,
                                      items: category,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _autovalidate = true;
                                isLoading = true;
                              });
                              StorageTaskSnapshot snapshot = await storage
                                  .ref()
                                  .child("images/${uuid.v1()}")
                                  .putFile(_image)
                                  .onComplete;
                              if (snapshot.error == null) {
                                final String downloadUrl =
                                    await snapshot.ref.getDownloadURL();
                                firestore.collection('product').add({
                                  "name": productName.text,
                                  "price": num.tryParse(price.text),
                                  "images": [downloadUrl],
                                  "category": selectedCategory,
                                  "desc": description.text
                                });
                                Fluttertoast.showToast(
                                    msg: 'Product is up now! :)');
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Error: ${snapshot.error.toString()}");
                              }
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: isLoading,
            child: Center(child: CircularProgressIndicator()))
      ]),
    );
  }
}
