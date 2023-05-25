import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse('asset:///w/index.html'),
            headers: {'Content-Type': 'text/html'},
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
            ),
          ),
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
              handlerName: 'myHandler',
              callback: (args) {
                // Handle JavaScript message
              },
            );
          },
        ),
      ),
    );
  }
}
