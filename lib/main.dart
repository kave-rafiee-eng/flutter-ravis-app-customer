import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/checkForLogin.dart';
import 'package:flutter_application_1/providers/themeModeProvider.dart';
// import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
// import 'package:flutter_application_1/screens/ravis_tabs.dart';
// import 'package:flutter_application_1/quiz/Quiz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF034A85),
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF034A85),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
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

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // return MaterialApp(theme: theme, home: TabsScreen());
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: themeMode,
      scrollBehavior: MyScrollBehavior(),
      debugShowCheckedModeBanner: false,
      // home: ServerconnectionStart(),
      home: const CheckForLogin(),
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