import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/expense_item.dart';
import 'package:flutter_application_1/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        return ExpenseItem(expenses[index]);
      },
    );
  }
}
