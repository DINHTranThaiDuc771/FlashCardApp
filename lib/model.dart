import 'package:flutter/cupertino.dart';

@immutable
// ignore: must_be_immutable
class Dictionary {
  static int numberOfDict = 0;
  late final int id;
  // ignore: prefer_collection_literals
  final String name;
  final String description;
  var dictionary = {};
  void addTerm( {required String term,required String definition}) {
    dictionary = {...dictionary, term: definition};
  }

  void removeTerm(String term) {
    dictionary.remove(term);
  }

  @override
  String toString() {
    return name + description!;
  }

  Dictionary({required this.name, required this.description}) {
    id = numberOfDict;
    numberOfDict++;
  }
  Dictionary copywith({int? id, required String name, required String description}) {
    return Dictionary(name: name, description: description);
  }
}
