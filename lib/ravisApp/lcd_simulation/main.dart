import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/enum.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/RenderHome.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';
import 'package:flutter_application_1/ravisApp/service/menu_service.dart';
import 'package:flutter_application_1/ravisApp/widgets/home_drawer.dart';
import 'dart:ui';

void main() => runApp(const MyApp());

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: LoadDataMenu(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class LoadDataMenu extends StatelessWidget {
  final MenuService _service = MenuService();

  LoadDataMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuType>>(
      future: _service.loadMenus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final menus = snapshot.data!;

        return DemoPage(menus: menus);
        // return Rendermanager(menus: menus);
      },
    );
  }
}

class DemoPage extends StatefulWidget {
  final List<MenuType> menus;
  const DemoPage({super.key, required this.menus});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  LanguageEnum language = LanguageEnum.persian;
  String _lang = LanguageEnum.persian.name;

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //enum LanguageEnum { english, persian, arabic, turkish, russian, german }
  final _langs = const <LanguageEnum, String>{
    LanguageEnum.persian: 'فارسی',
    LanguageEnum.english: 'English',
    LanguageEnum.arabic: 'العربية',
    LanguageEnum.turkish: 'Türkçe',
    LanguageEnum.russian: 'Русский',
    LanguageEnum.german: 'Deutsch',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.elevator),
            activeIcon: Icon(Icons.elevator, color: Colors.red),
            label: 'app',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat Ai'),
        ],
      ),
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('BoolGridPainter Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _lang,
                  borderRadius: BorderRadius.circular(12),
                  icon: const Icon(Icons.language),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onChanged: (value) {
                    if (value == null) return;
                    _lang = value;
                    setState(() {
                      switch (value) {
                        case 'english':
                          language = LanguageEnum.english;
                          break;
                        case "persian":
                          language = LanguageEnum.persian;
                          break;
                        case "arabic":
                          language = LanguageEnum.arabic;
                          break;
                        case "german":
                          language = LanguageEnum.german;
                          break;
                        case "russian":
                          language = LanguageEnum.russian;
                          break;
                        case "turkish":
                          language = LanguageEnum.turkish;
                          break;
                      }
                    });
                  },
                  items: _langs.entries
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.key.name.toString(),
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Rendermanager(menus: widget.menus, language: language),
    );
  }
}
