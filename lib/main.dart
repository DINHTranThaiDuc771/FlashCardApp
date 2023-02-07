import 'package:flutter/material.dart';
import 'model.dart';
import 'form.dart';
import 'dictPage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myAppStateProvider =
    StateNotifierProvider<DictNotifier, List<Dictionary>>((ref) {
  return DictNotifier();
});

class DictNotifier extends StateNotifier<List<Dictionary>> {
  DictNotifier() : super([]); //Initilize by an empty list
  void addDictionary(Dictionary dict) {
    state = [...state, dict];
  }

  void removeDictionary(Dictionary d) {
    state = [
      for (Dictionary dict in state)
        if (dict.id != d.id) dict
    ];
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Dictionary> myAppState = ref.watch(myAppStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const DictListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showInformationDialog(context);
          ref.read(myAppStateProvider.notifier).addDictionary(
              Dictionary(name: name!, description: "description"));
          print(myAppState);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DictListPage extends ConsumerWidget {
  const DictListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Dictionary> myAppState = ref.watch(myAppStateProvider);
    if (myAppState.isEmpty) {
      return const Center(
        child: Text("No Dictionary yet"),
      );
    }
    return ListView(
      children: [for (var dict in myAppState) CardItem(dict: dict)],
    );
  }
}

// ignore: must_be_immutable
class CardItem extends StatelessWidget {
  late final String _name;
  late Dictionary dictionary;
  CardItem({super.key, required Dictionary dict}) {
    super.key;
    _name = dict.name;
    this.dictionary = dict;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Card(
        // clipBehavior is necessary because, without it, the InkWell's animation
        // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
        // This comes with a small performance cost, and you should not set [clipBehavior]
        // unless you need it.
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // add open new page
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  DictPage(dict: dictionary)));
          },
          child: SizedBox(
            width: 300,
            height: 100,
            child: Text(_name),
          ),
        ),
      ),
    );
  }
}
