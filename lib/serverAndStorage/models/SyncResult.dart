import 'package:flutter_application_1/serverAndStorage/models/appInternalData.dart';

class SyncResult {
  final AppInternalData appData;
  final List<String> savedFiles;
  final List<String> failedFiles;

  SyncResult({
    required this.appData,
    required this.savedFiles,
    required this.failedFiles,
  });

  bool get hasAnySuccess => savedFiles.isNotEmpty;

  String get message {
    if (failedFiles.isEmpty) {
      return 'All data synced successfully.';
    }
    return 'Failed to download: ${failedFiles.join(', ')}';
  }
}
