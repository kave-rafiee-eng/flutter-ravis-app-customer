import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.answerText,
    required this.onTab,
    super.key,
  });

  final String answerText;
  final void Function() onTab;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTab,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      ),
      child: Text(answerText, textAlign: TextAlign.center),
    );
  }
}
