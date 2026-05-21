import 'dart:ffi';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  late double _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly!', style: TextStyle(fontSize: 25)),
        centerTitle: true,
        backgroundColor: Colors.red,
        toolbarHeight: _deviceHeight * 0.15,
      ),
      body: _taskList(),
      floatingActionButton: _addTaskBtn(),
    );
  }

  Widget _addTaskBtn() {
    return FloatingActionButton(
      onPressed: () {
        print('pressed Button');
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _taskList() {
    return ListView(
      children: [
        ListTile(
          title: Text(
            'do Laundry!',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          subtitle: Text(DateTime.now().toString()),
          trailing: const Icon(Icons.check_box_outlined, color: Colors.red),
        ),
      ],
    );
  }
}
