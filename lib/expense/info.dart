import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

enum Category { food, travel, entertainment, utilities, other }

const categoryIcons = {
  Category.food: Icons.restaurant,
  Category.travel: Icons.flight_takeoff,
  Category.entertainment: Icons.movie,
  Category.utilities: Icons.home,
  Category.other: Icons.shopping_cart,
};

class Info {
  Info({
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final Category category;

  String get formattedDate {
    return DateFormat.yMMMMd().format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  final Category category;
  final List<Info> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }

  static ExpenseBucket forCategory(List<Info> expenses, Category category) {
    final filteredExpenses = expenses
        .where((expense) => expense.category == category)
        .toList();
    return ExpenseBucket(category: category, expenses: filteredExpenses);
  }
}
