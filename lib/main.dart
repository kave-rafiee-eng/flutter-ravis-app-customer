import 'package:flutter/material.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
// import 'package:flutter_application_1/screens/ravis_tabs.dart';
// import 'package:flutter_application_1/quiz/Quiz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 3, 74, 133),
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const ProviderScope(child: App()));
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(theme: theme, home: TabsScreen());
    return MaterialApp(
      theme: theme,
      scrollBehavior: MyScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: ServerconnectionStart(),
    );
  }
}


// var kColorSchema = ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent);
// var kDarkColorSchema = ColorScheme.fromSeed(
//   seedColor: const Color.fromARGB(255, 47, 42, 61),
//   brightness: Brightness.dark,
// );
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
//     fn,
//   ) {
//     runApp(
//       MaterialApp(
//         darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorSchema),
//         theme: ThemeData(
//           scaffoldBackgroundColor: kColorSchema.primary,
//           colorScheme: kColorSchema,
//           appBarTheme: AppBarTheme(
//             backgroundColor: kColorSchema.onPrimaryContainer,
//             foregroundColor: kColorSchema.primaryContainer,
//           ),
//           cardTheme: CardThemeData(
//             color: kColorSchema.secondaryContainer,
//             margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kColorSchema.primaryContainer,
//             ),
//           ),
//           textTheme: TextTheme(
//             titleLarge: TextStyle(fontSize: 20),
//             titleSmall: TextStyle(fontSize: 12),
//           ),
//         ),
//         themeMode: ThemeMode.light,
//         home: Expenses(),
//       ),
//     );
//   });

// }


  // runApp(Quiz());

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