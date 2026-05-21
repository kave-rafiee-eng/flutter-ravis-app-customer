import 'package:flutter/material.dart';
import 'package:flutter_application_1/expenses.dart';
import 'package:flutter_application_1/quiz/Quiz.dart';

void main() {
  // runApp(Quiz());
  runApp(MaterialApp(theme: ThemeData(useMaterial3: true), home: Expenses()));
}
