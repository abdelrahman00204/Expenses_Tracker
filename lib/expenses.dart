import 'package:flutter/material.dart';
import 'package:expenses_tracker/expense/info.dart';
import 'package:expenses_tracker/expense/add_expense.dart';
import 'package:expenses_tracker/chart/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('expenses');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _registeredExpenses = decoded
            .map(
              (e) => Info(
                title: e['title'],
                amount: e['amount'],
                date: DateTime.parse(e['date']),
                category: Category.values.firstWhere(
                  (c) => c.name == e['category'],
                ),
              ),
            )
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses(); // 👈 this loads saved data on startup
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _registeredExpenses
          .map(
            (e) => {
              'title': e.title,
              'amount': e.amount,
              'date': e.date.toIso8601String(),
              'category': e.category.name,
            },
          )
          .toList(),
    );
    await prefs.setString('expenses', encoded);
  }

  List<Info> _registeredExpenses = [];
  void _addExpense(Info expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
    _saveExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width;

    Widget layout = Expanded(
      child: Center(
        child: ListView.builder(
          itemCount: _registeredExpenses.length,
          itemBuilder: (ctx, index) => Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            key: ValueKey(_registeredExpenses[index].id),
            onDismissed: (direction) {
              final removedExpense =
                  _registeredExpenses[index]; // save before removal
              final removedIndex = index;

              setState(() {
                _registeredExpenses.removeAt(removedIndex);
              });
              _saveExpenses();

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: const Text('Expense removed'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _registeredExpenses.insert(
                          removedIndex,
                          removedExpense,
                        );
                      });
                      _saveExpenses();
                    },
                  ),
                ),
              );
            },
            child: Card(
              shadowColor: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Text(_registeredExpenses[index].title),
                    Row(
                      children: [
                        Text(
                          '\$ ${_registeredExpenses[index].amount.toStringAsFixed(2)}',
                        ),
                        const Spacer(),
                        Icon(
                          categoryIcons[_registeredExpenses[index].category],
                        ),
                        Text(_registeredExpenses[index].formattedDate),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    /////////////////////////////////////////////////////
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (ctx) => AddExpense(onAddExpense: _addExpense),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text('Expenses Tracker'),
      ),

      body: isSmallScreen < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                layout,
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                layout,
              ],
            ),
    );
  }
}
