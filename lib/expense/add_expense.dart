import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenses_tracker/expense/info.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key, required this.onAddExpense});
  final void Function(Info) onAddExpense;
  @override
  State<AddExpense> createState() {
    return _AddExpenseState();
  }
}

class _AddExpenseState extends State<AddExpense> {
  final _titleChange = TextEditingController();
  final _amountChange = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;
  @override
  void dispose() {
    _titleChange.dispose();
    _amountChange.dispose();
    super.dispose();
  }

  void _checkExpense() {
    final enteredAmount = double.tryParse(_amountChange.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleChange.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null ||
        _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('Invalid Input')),
      );
      return;
    }
    widget.onAddExpense(
      Info(
        title: _titleChange.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory!,
      ),
    );
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ); //.then( (value) {
    // Handle the selected date
    //});
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  TextField(
                    maxLength: 50,
                    decoration: InputDecoration(label: Text('Title')),
                    controller: _titleChange,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text('Amount'),
                            prefix: Text('\$ '),
                          ),
                          controller: _amountChange,
                        ),
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No Date Chosen'
                                : (DateFormat.yMMMMd().format(_selectedDate!)),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (values) {
                          setState(() {
                            _selectedCategory = values;
                          });
                        },
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          _checkExpense();
                        },
                        child: Text('Save Expense'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
