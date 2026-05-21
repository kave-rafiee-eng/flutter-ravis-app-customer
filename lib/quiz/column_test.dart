import 'package:flutter/material.dart';

class ColumnTest extends StatelessWidget {
  const ColumnTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sandBox'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(width: 100, color: Colors.red, child: const Text('one')),
          Container(width: 200, color: Colors.green, child: const Text('two')),
          Container(width: 300, color: Colors.blue, child: const Text('three')),
        ],
      ),
    );
  }
}
