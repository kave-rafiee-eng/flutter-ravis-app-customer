import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/widgets/PdfViwer.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadFile(String url, String fileName) async {
  if (kIsWeb) {
    throw UnsupportedError('File download is not supported on web.');
  }

  final preDir = await getApplicationDocumentsDirectory();
  bool isExist = await File('${preDir.path}/$fileName').exists();
  if (isExist) return '${preDir.path}/$fileName';

  final httpClient = HttpClient();

  try {
    final request = await httpClient.getUrl(
      Uri.parse('$url?filename=$fileName'),
    );
    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception('HTTP error ${response.statusCode}');
    }

    final bytes = await consolidateHttpClientResponseBytes(response);
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';

    await File(filePath).writeAsBytes(bytes, flush: true);

    return filePath;
  } finally {
    httpClient.close();
  }
}

//http://localhost:3000/pdf/download
class PdfDownloaderAndViwer extends StatelessWidget {
  final String fileName;
  const PdfDownloaderAndViwer({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: downloadFile('http://10.38.181.179:3000/pdf/download', fileName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _PdfLoadingView(fileName: fileName);
        }

        if (snapshot.hasError) {
          return _PdfDownloadErrorView(
            fileName: fileName,
            error: snapshot.error,
          );
        }

        if (snapshot.hasData) {
          return PdfViwerKave(pdfPath: snapshot.data!);
        }

        return const SizedBox();
      },
    );
  }
}

class _PdfLoadingView extends StatelessWidget {
  final String fileName;

  const _PdfLoadingView({required this.fileName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Downloading PDF...',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait a moment',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  fileName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PdfDownloadErrorView extends StatelessWidget {
  final String fileName;
  final Object? error;

  const _PdfDownloadErrorView({required this.fileName, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Failed'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 36,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Could not download file',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                fileName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${error ?? 'Unknown error'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
