import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/expense_item.dart';
import 'package:flutter_application_1/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemove,
  });

  final void Function(Expense expense) onRemove;

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          background: Container(color: Theme.of(context).colorScheme.error),
          key: ValueKey(expenses[index]),
          onDismissed: (e) {
            onRemove(expenses[index]);
          },
          child: ExpenseItem(expenses[index]),
        );
      },
    );
  }
}
