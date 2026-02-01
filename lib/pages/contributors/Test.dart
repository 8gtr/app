import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ReorderableListExample());
  }
}

class ReorderableListExample extends StatefulWidget {
  @override
  _ReorderableListExampleState createState() => _ReorderableListExampleState();
}

class _ReorderableListExampleState extends State<ReorderableListExample> {
  // List of items
  List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Dates', 'Elderberry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reorderable List Example')),
      body: ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = fruits.removeAt(oldIndex);
          fruits.insert(newIndex, item);
          setState(() {});
        },
        children: [
          for (int i = 0; i < fruits.length; i++)
            ListTile(
              key: ValueKey(fruits[i]), // Each item needs a unique key
              leading: ReorderableDragStartListener(index: i, child: Icon(Icons.drag_indicator)),
              title: Text(fruits[i]),
            ),
        ],
      ),
    );
  }
}
