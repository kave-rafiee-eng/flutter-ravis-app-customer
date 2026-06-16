import 'package:flutter/material.dart';
// import 'package:flutter_application_1/ravisApp/PdfViwer.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/lcd_simulation/Renderes/Rendermanager.dart';
import 'package:flutter_application_1/lcd_simulation/models/menu_model.dart';
// import 'package:flutter_application_1/lcd_simulation/service/menu_service.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
// import 'package:flutter_application_1/widgets/LoadingView.dart';
// import 'package:flutter_application_1/ravisApp/widgets/home_drawer.dart';
// import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BoardEnum { advance, terse }

class MenusScreen extends ConsumerWidget {
  final List<MenuType> menus;
  final BoardEnum board;
  const MenusScreen({super.key, required this.menus, required this.board});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LanguageEnum language = ref.watch(languageNotifierProvider);
    String title = '';
    if (board == BoardEnum.terse) title = 'Terse';
    if (board == BoardEnum.advance) title = 'Advance';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: Selectlanguage()),
          ),
        ],
      ),
      body: Rendermanager(menus: menus, language: language, board: board),
    );
  }
}


// void main() => runApp(const MyApp());

// class MyScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     PointerDeviceKind.touch,
//     PointerDeviceKind.mouse,
//   };
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scrollBehavior: MyScrollBehavior(),
//       debugShowCheckedModeBanner: false,

//       home: LoadDataMenu(),
//       // home: PdfViwer(pdfPath: 'assets/sample.pdf'),
//       theme: ThemeData(useMaterial3: true),
//     );
//   }
// }

// class LoadDataMenu extends StatelessWidget {
//   final MenuService _service = MenuService();

//   LoadDataMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<MenuType>>(
//       future: _service.loadMenus(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return LoadingView();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         final menus = snapshot.data!;

//         return MenusScreen(menus: menus);
//         // return Rendermanager(menus: menus);
//       },
//     );
//   }
// }

