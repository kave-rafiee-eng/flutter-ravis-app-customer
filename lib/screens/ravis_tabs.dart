import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/home_drawer.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RavisTabs extends ConsumerStatefulWidget {
  const RavisTabs({super.key});

  @override
  ConsumerState<RavisTabs> createState() => _RavisTabsState();
}

class _RavisTabsState extends ConsumerState<RavisTabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageNotifierProvider);
    final theme = Theme.of(context);

    const langs = <LanguageEnum, String>{
      LanguageEnum.persian: 'فارسی',
      LanguageEnum.english: 'English',
      LanguageEnum.arabic: 'العربية',
      LanguageEnum.turkish: 'Türkçe',
      LanguageEnum.russian: 'Русский',
      LanguageEnum.german: 'Deutsch',
    };

    Widget activeScreen = Text('home page');
    if (_selectedPageIndex == 1) {
      activeScreen = Center(child: Text('Ai mode'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Ravis"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: language.name,
                  borderRadius: BorderRadius.circular(12),
                  icon: const Icon(Icons.language),
                  dropdownColor: theme.colorScheme.surface,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(languageNotifierProvider.notifier)
                        .changeLanguage(LanguageEnum.values.byName(value));
                  },
                  items: langs.entries
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.key.name,
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
