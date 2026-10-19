import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const testWebViewUrl = 'http://109.125.149.108:3002/';

class WebViewTestPage extends StatefulWidget {
  const WebViewTestPage({super.key});

  @override
  State<WebViewTestPage> createState() => _WebViewTestPageState();
}

class _WebViewTestPageState extends State<WebViewTestPage> {
  late final WebViewController _controller;
  var _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _loadingProgress = progress);
          },
        ),
      )
      ..loadRequest(Uri.parse(testWebViewUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_loadingProgress < 100)
          LinearProgressIndicator(value: _loadingProgress / 100),
        Expanded(child: WebViewWidget(controller: _controller)),
      ],
    );
  }
}
