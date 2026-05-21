import 'package:flutter/material.dart';
import 'package:flutter_application_1/expenses.dart';
import 'package:flutter_application_1/quiz/Quiz.dart';
import 'package:flutter/services.dart';

// var kColorSchema = ColorScheme(
//   brightness: Brightness.light,
//   primary: Colors.deepPurple,
//   onPrimary: Colors.white,
//   secondary: Colors.teal,
//   onSecondary: Colors.white,
//   error: Colors.red,
//   onError: Colors.white,
//   surface: Colors.grey[100]!,
//   onSurface: Colors.black,
// );
var kColorSchema = ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent);

var kDarkColorSchema = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 47, 42, 61),
  brightness: Brightness.dark,
);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    fn,
  ) {
    runApp(
      MaterialApp(
        darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorSchema),
        theme: ThemeData(
          scaffoldBackgroundColor: kColorSchema.primary,
          colorScheme: kColorSchema,
          appBarTheme: AppBarTheme(
            backgroundColor: kColorSchema.onPrimaryContainer,
            foregroundColor: kColorSchema.primaryContainer,
          ),
          cardTheme: CardThemeData(
            color: kColorSchema.secondaryContainer,
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorSchema.primaryContainer,
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(fontSize: 20),
            titleSmall: TextStyle(fontSize: 12),
          ),
        ),
        themeMode: ThemeMode.light,
        home: Expenses(),
      ),
    );
  });

  // runApp(Quiz());
}
