import 'package:flutter/material.dart';
import 'model.dart';
import 'form.dart';
import 'dictPage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final lstDictProvider =
    StateNotifierProvider<DictListNotifier, List<Dictionary>>((ref) {
  return DictListNotifier();
});

class DictListNotifier extends StateNotifier<List<Dictionary>> {
  DictListNotifier() : super([]); //Initilize by an empty list
  void addDictionary(Dictionary dict) {
    state = [...state, dict];
    // Dont use state.add(dict), because it will not change anything. Cause the reference stay the same
    //"You might be thinking, “Why didn’t you use .add and .remove here?” The reason is 
    //that the state must be changed, resulting in oldState == newState as false, 
    //but methods like .add mutates the list in place, so the equality is preserved. 
    //That’s why both the addBook and removeBook methods have something like state = [...state, book], 
    //which provides an entirely new list in the state."

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
    List<Dictionary> lstDict = ref.watch(lstDictProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const DictListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showInformationDialog(context);
          ref.read(lstDictProvider.notifier).addDictionary(
              Dictionary(name: name!, description: "description"));
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
    List<Dictionary> lstDict = ref.watch(lstDictProvider);
    if (lstDict.isEmpty) {
      return const Center(
        child: Text("No Dictionary yet"),
      );
    }
    return ListView(
      children: [for (var dict in lstDict) CardItem(dict: dict)],
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DictPage(dict: dictionary)));
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
