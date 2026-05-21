import 'package:flutter/material.dart';
import 'package:flutter_application_1/quiz/data/questions.dart';
import 'package:flutter_application_1/quiz/question_summary.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.chosenAnswer,
    required this.handleReset,
    super.key,
  });

  final void Function() handleReset;

  final List<String> chosenAnswer;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'currect_answer': questions[i].answers[0],
        'user_answer': chosenAnswer[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestion = questions.length;
    final numCurrentQuestion = summaryData.where((data) {
      return data['user_answer'] == data['currect_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'you answer $numCurrentQuestion of $numTotalQuestion question currectly!',
            ),
            const SizedBox(height: 30),
            QuestionSummary(getSummaryData()),
            const SizedBox(height: 30),
            TextButton(onPressed: handleReset, child: Text('restart quiz')),
          ],
        ),
      ),
    );
  }
}
