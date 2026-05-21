import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  final String title;
  final int count;

  const MyWidget({super.key, required this.title, required this.count});
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("${widget.title} - ${widget.count}");
  }
}
