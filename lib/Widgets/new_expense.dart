import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firsttDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;

    final pickerDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firsttDate,
      lastDate: lastDate,
    );

    setState(() {
      _selectedDate = pickerDate;
    });

    // showDatePicker(
    //   context: context,
    //   initialDate: now,
    //   firstDate: firsttDate,
    //   lastDate: lastDate,
    // ).then((value) {});
  }

  void _submitExpenseData() {
    final enteredAmout = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmout == null || enteredAmout <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          titleTextStyle: TextStyle(backgroundColor: Colors.red),
          title: const Text('inalid input'),
          content: const Text('Please make sure a valid data entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okey'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmout,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            // onChanged: _saveTitleInput,
            maxLength: 50,
            decoration: InputDecoration(label: Text('title')),
            keyboardType: TextInputType.text,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    label: Text('amount'),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : formater.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase().toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == null) return;
                    _selectedCategory = value;
                  });
                },
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: Text('save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
