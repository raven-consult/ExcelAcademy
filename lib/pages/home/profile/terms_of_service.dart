import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({super.key});

  @override
  State<TermsOfService> createState() => _TermsOfService();
}

class _TermsOfService extends State<TermsOfService> {
  late WebViewController _controller;

  double _progress = 0;
  final url = "https://excel-academy-online.web.app/terms_of_service.html";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
        ),
      );
  }

  bool _hasDownloadedComplete() => _progress == 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Terms of Service"),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            height: _hasDownloadedComplete() ? 0 : 8,
            duration: const Duration(milliseconds: 500),
            child: LinearProgressIndicator(
              value: _progress,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          Expanded(
            child: WebViewWidget(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}
