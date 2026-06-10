import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/PdfViwer.dart';
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
class pdfDownloaderAndView extends StatelessWidget {
  final String fileName;
  const pdfDownloaderAndView({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: downloadFile('http://10.38.181.179:3000/pdf/download', fileName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('error : ${snapshot.error}');
        }

        if (snapshot.hasData) {
          return PdfViwerKave(pdfPath: snapshot.data!);
        }

        return const SizedBox();
      },
    );
  }
}

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: pdfDownloaderAndView(fileName: "mc60_mqtt.pdf"),
    );
  }
}
