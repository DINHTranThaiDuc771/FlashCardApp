import 'package:flutter/cupertino.dart';

@immutable
// ignore: must_be_immutable
class Dictionary {
  static int numberOfDict = 0;
  late final int id;
  // ignore: prefer_collection_literals
  final String name;
  final String description;
  List lstTerm = [];
  void addTerm( {required String term,required String definition}) {
    lstTerm = [...lstTerm,Term(term: term,def:definition)];
  }

  void removeTerm(Term term) {
    lstTerm.remove(term);
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
class Term {
  final String term;
  final String def;
  const Term ({required this.term,required this.def});
  Term copyWith (String term, String def){
    return Term (term: term ,def : def);
  }

}