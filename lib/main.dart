import 'package:flutter/material.dart';
import 'package:expenses_tracker/expenses.dart';

//import 'package:flutter/services.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 75, 13, 85),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 56, 46, 93),
  brightness: Brightness.dark,
);

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([
  //  DeviceOrientation.portraitUp,
  // ]).then((fn) {}); 

  // Locking the orientation to portrait mode only
  // to prevent layout issues when the device is rotated.
  // This is optional and can be removed if you want to support both orientations.
  // to make it work put the whole runapp in the then() method of setPreferredOrientations


  runApp(
    MaterialApp(
      darkTheme: ThemeData().copyWith(
        colorScheme: kDarkColorScheme,
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
          ),
        ),
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kDarkColorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        bottomSheetTheme: BottomSheetThemeData().copyWith(
          backgroundColor: kDarkColorScheme.primaryContainer,
        ),
        scaffoldBackgroundColor: kDarkColorScheme.onSecondaryContainer,
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,

        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.primaryContainer,
            fontSize: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kColorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      themeMode: ThemeMode.system,
      home: Expenses(),
    ),
  );
}
