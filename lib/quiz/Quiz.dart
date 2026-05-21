import 'package:flutter/material.dart';
import 'package:flutter_application_1/quiz/Question_screen.dart';
import 'package:flutter_application_1/quiz/result_screen.dart';
import 'package:flutter_application_1/quiz/start_screen.dart';
import 'package:flutter_application_1/quiz/data/questions.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  // Widget? activeScreen;

  List<String> selectedAnswer = [];
  var activeScreen = 'start-screen';

  // @override
  // void initState() {
  //   // activeScreen = StartScreen(switchScreen);
  //   super.initState();
  // }

  void switchScreen() {
    setState(() {
      // activeScreen = QuestionScreen();
      activeScreen = 'question-screen';
    });
  }

  void handleReset() {
    setState(() {
      activeScreen = 'start-screen';
      selectedAnswer = [];
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswer.add(answer);
    if (questions.length == selectedAnswer.length) {
      setState(() {
        activeScreen = 'result-screen';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartScreen(switchScreen);
    if (activeScreen == 'question-screen') {
      screenWidget = QuestionScreen(onSelectAnswer: chooseAnswer);
    } else if (activeScreen == 'result-screen') {
      screenWidget = ResultScreen(
        chosenAnswer: selectedAnswer,
        handleReset: handleReset,
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 179, 46, 219),
                Color.fromARGB(255, 21, 34, 206),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
