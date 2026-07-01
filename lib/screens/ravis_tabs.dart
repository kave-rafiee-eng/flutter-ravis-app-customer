import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatbot/chatbotScreen.dart';
import 'package:flutter_application_1/screens/HomeScreen.dart';
import 'package:flutter_application_1/serverAndStorage/models/SyncResult.dart';
import 'package:flutter_application_1/serverAndStorage/models/appInternalData.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:flutter_application_1/tickets/Screens/listTicketsScreen.dart';
import 'package:flutter_application_1/widgets/home_drawer.dart';
import 'package:flutter_application_1/providers/themeModeProvider.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RavisTabs extends ConsumerStatefulWidget {
  final SyncResult? syncResult;

  const RavisTabs({this.syncResult, super.key});

  @override
  ConsumerState<RavisTabs> createState() => _RavisTabsState();
}

class _RavisTabsState extends ConsumerState<RavisTabs> {
  int _selectedPageIndex = 0;
  late AppInternalData appData;
  bool _unreadMessageShown = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUnreadTicketsMessageIfNeeded();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    var temp = await ServerAndStorage().readAppInternalDataFromFile();

    setState(() {
      appData = temp;
    });
  }

  void _showUnreadTicketsMessageIfNeeded() {
    if (_unreadMessageShown || !mounted) return;

    final syncResult = widget.syncResult;
    final unreadCount = syncResult?.unreadedTicketsCount ?? 0;
    if (syncResult == null || unreadCount <= 0) return;

    _unreadMessageShown = true;
    _showUnreadTicketsDialog(unreadCount);
  }

  void _showUnreadTicketsDialog(int count) {
    final scheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.mark_email_unread_rounded,
            size: 36,
            color: scheme.error,
          ),
          title: const Text('پیام جدید', textDirection: TextDirection.rtl),
          content: Text(
            'شما $count تیکت خوانده‌نشده دارید.\nآیا می‌خواهید آن‌ها را ببینید؟',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('بعداً'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListTicketsScreen()),
                );
              },
              child: const Text('مشاهده تیکت‌ها'),
            ),
          ],
        );
      },
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final isDarkMode = themeMode == ThemeMode.dark;

    Widget activeScreen = Homescreen();
    if (_selectedPageIndex == 1) {
      activeScreen = ChatScreen(appData: appData);
    }

    return Scaffold(
      appBar: AppBar(
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
