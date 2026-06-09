import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViwer extends StatefulWidget {
  final String pdfPath;

  const PdfViwer({super.key, required this.pdfPath});

  @override
  State<PdfViwer> createState() => _PdfViwerState();
}

class _PdfViwerState extends State<PdfViwer> {
  late PdfControllerPinch pdfControllerPinch;
  int totoalPage = 0;
  int currentPage = 1;
  @override
  void initState() {
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.pdfPath),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pdf viwer'), backgroundColor: Colors.red),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('totoal : $totoalPage'),
            IconButton(
              onPressed: () {
                pdfControllerPinch.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text('Pages : $currentPage'),
            IconButton(
              onPressed: () {
                pdfControllerPinch.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
        _pdfView(),
      ],
    );
  }

  Widget _pdfView() {
    return Expanded(
      child: PdfViewPinch(
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
        onDocumentLoaded: (doc) {
          setState(() {
            totoalPage = doc.pagesCount;
          });
        },
        controller: pdfControllerPinch,
      ),
    );
  }
}
