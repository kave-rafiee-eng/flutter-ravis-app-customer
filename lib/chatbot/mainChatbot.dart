// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/chatbot/chatbotScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_application_1/providers/themeModeProvider.dart';
// import 'dart:ui';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum BoardEnum { advance, terse }

// final lightTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: const Color(0xFF034A85),
//     brightness: Brightness.light,
//   ),
//   textTheme: GoogleFonts.latoTextTheme(),
// );

// final darkTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: const Color(0xFF034A85),
//     brightness: Brightness.dark,
//   ),
//   textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
// );

// class MyScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     PointerDeviceKind.touch,
//     PointerDeviceKind.mouse,
//   };
// }

// void main() => runApp(const App());

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final themeMode = ref.watch(themeModeProvider);
//     // return MaterialApp(theme: theme, home: TabsScreen());
//     return MaterialApp(
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       // themeMode: ThemeMode.system,
//       themeMode: ThemeMode.light,
//       scrollBehavior: MyScrollBehavior(),
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(body: ChatScreen()),
//     );
//   }
// }
