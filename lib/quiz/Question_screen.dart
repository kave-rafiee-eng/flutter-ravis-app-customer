import 'package:flutter/material.dart';
import 'package:flutter_application_1/quiz/answer_button.dart';
import 'package:flutter_application_1/quiz/data/questions.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;
  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var currentQuestionIndex = 0;

  void answerQuestion(String slected) {
    widget.onSelectAnswer(slected);
    setState(() {
      if (currentQuestionIndex < questions.length - 1) currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQestion = questions[currentQuestionIndex];

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.all(60),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQestion.text,
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ...currentQestion.getShuffledAnswer().map((answer) {
              return AnswerButton(
                answerText: answer,
                onTab: () {
                  answerQuestion(answer);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
