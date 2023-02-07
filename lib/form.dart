import 'package:flutter/material.dart';

import 'model.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _textEditingController = TextEditingController();


Future<String?> showInformationDialog(BuildContext context) async {
  //showDialog<T?> return a Future<T> (an object type T that returned in the Fture)
  //that value is the value of Navigator.of(context).pop(value);
  //this Navigator.of(context).pop(value) will close dialog too,
  //value could be primitive data type, or be boxed in an OBJECT
  return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _textEditingController,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Enter any text";
                  },
                  decoration:
                      const InputDecoration(hintText: "Please Enter Text"),
                ),
              ],
            ),
          ),
          title: const Text('Enter your dictionary\'s name'),
          actions: <Widget>[
            InkWell(
              child: const Text('Add'),
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Do something like updating SharedPreferences or User Settings etc.
                  Navigator.of(context).pop(_textEditingController
                      .text); //return value of show Dialog
                  _textEditingController.clear();
                }
              },
            ),
          ],
        );
      });
}


