import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/ravis_tabs.dart';
import 'package:flutter_application_1/serverAndStorage/models/SyncResult.dart';
import 'package:flutter_application_1/serverAndStorage/models/appInternalData.dart';
import 'package:flutter_application_1/serverAndStorage/widgets/SyncErrorView.dart';
import 'package:flutter_application_1/serverAndStorage/widgets/SyncLoadingView.dart';
import 'package:flutter_application_1/serverAndStorage/widgets/SyncPartialView.dart';
import 'package:flutter_application_1/tickets/ticket_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

const serverBaseUrl = 'http://109.125.149.108:3000';
// const serverBaseUrl = 'http://127.0.0.1:3000';
const pdfUrl = '$serverBaseUrl/pdf/download';

const _dataEndpoints = {
  'menu_advance.json': '$serverBaseUrl/menu-advance/',
  'menu_terse.json': '$serverBaseUrl/menu-terse/',
  'errorCodes.json': '$serverBaseUrl/error-code/',
  'documents.json': '$serverBaseUrl/documents/',
  'phonebook.json': '$serverBaseUrl/phonebook/',
};

class ServerconnectionStart extends ConsumerStatefulWidget {
  const ServerconnectionStart({super.key});

  @override
  ConsumerState<ServerconnectionStart> createState() =>
      _ServerconnectionStartState();
}

class _ServerconnectionStartState extends ConsumerState<ServerconnectionStart> {
  final ServerAndStorage _storage = ServerAndStorage();
  late Future<SyncResult> _syncFuture;

  @override
  void initState() {
    super.initState();
    _syncFuture = _storage.syncOnStartup();
  }

  void _retrySync() {
    setState(() {
      _syncFuture = _storage.syncOnStartup();
    });
  }

  void _openApp([SyncResult? syncResult]) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => RavisTabs(syncResult: syncResult)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SyncResult>(
      future: _syncFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SyncLoadingView();
        }

        if (snapshot.hasError) {
          return SyncErrorView(
            message: '${snapshot.error}',
            onRetry: _retrySync,
            onContinue: () => _openApp(),
          );
        }

        final result = snapshot.data!;
        if (!result.hasAnySuccess) {
          return SyncErrorView(
            message: result.message,
            onRetry: _retrySync,
            onContinue: () => _openApp(result),
          );
        }

        if (result.failedFiles.isNotEmpty) {
          return SyncPartialView(
            result: result,
            onContinue: () => _openApp(result),
            onRetry: _retrySync,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _openApp(result));
        return const SyncLoadingView(
          title: 'Starting app...',
          subtitle: 'Sync completed successfully',
        );
      },
    );
  }
}

class ServerAndStorage {
  static const _appDataFileName = 'AppInternalData.json';

  Future<bool> deletAppDataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_appDataFileName');

    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  }

  Future<bool> checkForLogin() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_appDataFileName');

    if (!await file.exists()) {
      return false;
    }

    try {
      final appData = await readAppInternalDataFromFile();
      final response = await http
          .get(
            Uri.parse(
              '$serverBaseUrl/user/${Uri.encodeComponent(appData.appId)}',
            ),
          )
          .timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 404:
          return false;
        default:
          return true;
      }
    } catch (err) {
      return true;
    }
  }

  Future<void> saveUserIdAfterLogin(String userId) async {
    await _saveAppInternalData(
      AppInternalData(appId: userId, dataVersion: '0', openByUpdate: false),
    );
  }

  Future<AppInternalData> readAppInternalDataFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_appDataFileName');

    if (await file.exists()) {
      try {
        final data = await file.readAsString();
        final jsonMap = jsonDecode(data) as Map<String, dynamic>;
        return AppInternalData.fromJson(jsonMap);
      } catch (err) {
        await file.delete();
      }
    }

    final appData = AppInternalData(
      // appId: const Uuid().v4(),
      appId: "default",
      dataVersion: 'error creat new',
      openByUpdate: false,
    );
    await _saveAppInternalData(appData);
    return appData;
  }

  Future<void> _saveAppInternalData(AppInternalData appData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_appDataFileName');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(appData.toJson()),
    );
  }

  Future<bool> fetchAndSave(String fileName, String urlEndpoint) async {
    if (kIsWeb) return false;

    try {
      final response = await http
          .get(Uri.parse(urlEndpoint))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        return false;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');

      if (await file.exists()) {
        await file.delete();
      }

      final data = jsonDecode(response.body);
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<SyncResult> getAllDataFromServer(
    AppInternalData appData,
    String version,
  ) async {
    final savedFiles = <String>[];
    final failedFiles = <String>[];

    for (final entry in _dataEndpoints.entries) {
      final success = await fetchAndSave(entry.key, entry.value);
      if (success) {
        savedFiles.add(entry.key);
      } else {
        failedFiles.add(entry.key);
      }
    }

    AppInternalData currentData = appData;

    if (savedFiles.isNotEmpty) {
      currentData = AppInternalData(
        appId: appData.appId,
        dataVersion: version,
        openByUpdate: true,
      );
      await _saveAppInternalData(currentData);
    }

    final unreadedTicketsCount = await _fetchUnreadTicketsCount(appData.appId);

    return SyncResult(
      appData: currentData,
      savedFiles: savedFiles,
      failedFiles: failedFiles,
      unreadedTicketsCount: unreadedTicketsCount,
    );
  }

  Future<int> _fetchUnreadTicketsCount(String userId) async {
    try {
      final count = await TicketApi.numOfUserUnreadedTickets(userId);
      return count.toInt();
    } catch (_) {
      return 0;
    }
  }

  Future<SyncResult> syncOnStartup() async {
    final appData = await readAppInternalDataFromFile();

    final response = await http
        .get(Uri.parse('$serverBaseUrl/version'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      if (response.body != appData.dataVersion) {
        return getAllDataFromServer(appData, response.body);
      }
    }

    appData.openByUpdate = false;
    await _saveAppInternalData(appData);

    final unreadedTicketsCount = await _fetchUnreadTicketsCount(appData.appId);

    return SyncResult(
      unreadedTicketsCount: unreadedTicketsCount,
      appData: appData,
      savedFiles: _dataEndpoints.keys.toList(),
      failedFiles: [],
    );
  }
}
