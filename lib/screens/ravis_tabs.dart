import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatbot/chatbotScreen.dart';
import 'package:flutter_application_1/screens/HomeScreen.dart';
import 'package:flutter_application_1/serverAndStorage/models/appInternalData.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:flutter_application_1/widgets/home_drawer.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/providers/themeModeProvider.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RavisTabs extends ConsumerStatefulWidget {
  const RavisTabs({super.key});

  @override
  ConsumerState<RavisTabs> createState() => _RavisTabsState();
}

class _RavisTabsState extends ConsumerState<RavisTabs> {
  int _selectedPageIndex = 0;
  late AppInternalData appData;

  @override
  void initState() {
    super.initState();
    appData = AppInternalData(
      appId: 'sdsdsd',
      dataVersion: 'sss',
      openByUpdate: false,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    var temp = await ServerAndStorage().readAppInternalDataFromFile();

    setState(() {
      appData = temp;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final isDarkMode = themeMode == ThemeMode.dark;

    const langs = <LanguageEnum, String>{
      LanguageEnum.persian: 'فارسی',
      LanguageEnum.english: 'English',
      LanguageEnum.arabic: 'العربية',
      LanguageEnum.turkish: 'Türkçe',
      LanguageEnum.russian: 'Русский',
      LanguageEnum.german: 'Deutsch',
    };

    Widget activeScreen = Homescreen();
    if (_selectedPageIndex == 1) {
      activeScreen = ChatScreen();
      // activeScreen = Center(
      //   child: Column(
      //     children: [
      //       Text('update:${appData.openByUpdate}'),
      //       Text('version:${appData.dataVersion}'),
      //       Text('id:${appData.appId}'),
      //     ],
      //   ),
      // );
    }

    return Scaffold(
      appBar: AppBar(
        // title: Text("Ravis"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.light_mode_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                    },
                  ),
                  Icon(
                    Icons.dark_mode_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: Selectlanguage()),
          ),
        ],
      ),
      drawer: HomeDrawer(),
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
      body: activeScreen,
    );
  }
}
