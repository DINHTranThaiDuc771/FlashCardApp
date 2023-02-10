import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'model.dart';

class DictPage extends StatefulWidget {
  Dictionary dict;
  DictPage({super.key, required this.dict}) {
    dict = dict;
  }

  @override
  State<DictPage> createState() => _DictPageState();
}

class _DictPageState extends State<DictPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: widget.dict.lstTerm.isEmpty
          ? Center(child: const Text('No term yet'))
          : Column(
              children: [
                Center(
                  child: TermCard(widget.dict.lstTerm[_currentIndex].term,
                      widget.dict.lstTerm[_currentIndex].def),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _showPreviousCard,
                        child: Icon(Icons.navigate_before)),
                    ElevatedButton(
                        onPressed: _showNextCard,
                        child: Icon(Icons.navigate_next))
                  ],
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Map<String, String>? data =
              await showTermDefAnalog(context, widget.dict);
          setState(() {
            widget.dict
                .addTerm(term: data!['term']!, definition: data['definition']!);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showNextCard() {
    setState(() {
      _currentIndex = _currentIndex + 1 >= widget.dict.lstTerm.length
          ? widget.dict.lstTerm.length - 1
          : _currentIndex + 1;
    });
  }

  _showPreviousCard() {
    setState(() {
      _currentIndex = _currentIndex - 1 < 0 ? 0 : _currentIndex - 1;
    });
  }

  Future<Map<String, String>?> showTermDefAnalog(
      BuildContext context, dict) async {
    //showDialog<T?> return a Future<T> (an object type T that returned in the Fture)
    //that value is the value of Navigator.of(context).pop(value);
    //this Navigator.of(context).pop(value) will close dialog too,
    //value could be primitive data type, or be boxed in an OBJECT
    return await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormFieldCustom(controller: _textTermControleur),
                  TextFormFieldCustom(controller: _textDefinitionControleur)
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
                    var data = {
                      'term': _textTermControleur.text,
                      'definition': _textDefinitionControleur.text
                    };

                    Navigator.of(context).pop(data);

                    _textDefinitionControleur.clear();
                    _textTermControleur.clear();
                  }
                },
              ),
            ],
          );
        });
  }
}

class TermCard extends StatelessWidget {
  final String term;
  final String definition;
  const TermCard(
    this.term,
    this.definition, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FlipCard(
        fill: Fill
            .fillBack, // Fill the back side of the card to make in the same size as the front.
        direction: FlipDirection.HORIZONTAL, // default
        side: CardSide.FRONT, // The side to initially display.
        front: Center(
          child: Container(
            color: Colors.red,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(child: Text(term)),
            ),
          ),
        ),
        back: Center(
          child: Container(
            color: Colors.red,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(child: Text(definition)),
            ),
          ),
        ),
      ),
    );
  }
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _textTermControleur = TextEditingController();
final TextEditingController _textDefinitionControleur = TextEditingController();

class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  const TextFormFieldCustom({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        return value!.isNotEmpty ? null : "Enter any text";
      },
      decoration: const InputDecoration(hintText: "Please Enter Text"),
    );
  }
}
