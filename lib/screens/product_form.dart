import 'package:agri_com/models/fruits.dart';
import 'package:agri_com/models/vegetables.dart';
import 'package:agri_com/services/product_service.dart';
import 'package:agri_com/widgets/category_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> with WidgetsBindingObserver {
  bool isLoading = false;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  TextEditingController productName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController subCategory = TextEditingController();
  String category = 'Fruits';

  switchCategory(val) {
    setState(() {
      category = val;
      subCategory.text = '';
    });
  }

  Map<String, List<String>> items = {'Fruits': [], 'Vegetables': []};

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    items['Fruits'].addAll(Fruits.keys.toList(growable: false));
    items['Vegetables'].addAll(Vegetables.keys.toList(growable: false));
    _focusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

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
              FormBuilder(
                key: _fbKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderImagePicker(
                        attribute: 'images',
                        decoration: const InputDecoration(
                          labelText: 'Images',
                        ),
                        defaultImage: NetworkImage(
                            'https://cohenwoodworking.com/wp-content/uploads/2016/09/image-placeholder-500x500.jpg'),
                        maxImages: 3,
                        iconColor: Colors.red,
                        // readOnly: true,
                        validators: [
                          FormBuilderValidators.required(),
                          (images) {
                            if (images.length < 2) {
                              return 'Two or more images required.';
                            }
                            return null;
                          }
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: 'name',
                        controller: productName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product name'),
                        validators: [FormBuilderValidators.required()],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: 'price',
                        controller: price,
                        decoration: InputDecoration(
                          labelText: 'Price per unit or kg',
                          prefix: Text('Rs '),
                        ),
                        valueTransformer: (text) {
                          return text == null ? null : num.tryParse(text);
                        },
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          (value) {
                            return num.tryParse(value) == 0
                                ? 'Price has to be greater than 0'
                                : null;
                          }
                        ],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: 'description',
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        focusNode: _focusNode,
                        minLines: 3,
                        maxLines: null,
                        validators: [FormBuilderValidators.required()],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderRadioGroup(
                        wrapAlignment: WrapAlignment.spaceAround,
                        attribute: 'category',
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        onChanged: (val) {
                          switchCategory(val);
                        },
                        initialValue: 'Fruits',
                        options: [
                          FormBuilderFieldOption(
                              value: 'Fruits', child: Text('Fruits')),
                          FormBuilderFieldOption(
                              value: 'Vegetables', child: Text('Vegetables')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderCustomField(
                        attribute: 'sub-category',
                        validators: [FormBuilderValidators.required()],
                        formField: FormField(
                          builder: (FormFieldState<dynamic> field) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Sub-category',
                                errorText: field.errorText,
                              ),
                              child: GestureDetector(
                                child: subCategory.text != ''
                                    ? Text(subCategory.text)
                                    : Text('Select sub-category '),
                                onTap: () async {
                                  String res = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SubCategoryDialog(
                                            items: items[category]);
                                      });
                                  setState(() {
                                    subCategory.text = res;
                                  });
                                  field.didChange(subCategory.text);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black)),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _autovalidateMode =
                                        AutovalidateMode.onUserInteraction;
                                  });
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    Map values = _fbKey.currentState.value;

                                    bool res =
                                        await ProductService.addProduct(values);

                                    setState(() {
                                      isLoading = false;
                                    });

                                    String msg = res == true
                                        ? 'Product added succesfully'
                                        : 'Failed to add product';

                                    Fluttertoast.showToast(msg: msg);

                                    if (res == true)
                                      Navigator.of(context).pop();
                                  }
                                },
                          child: Text(
                            'Done',
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
