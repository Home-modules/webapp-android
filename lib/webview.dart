// ignore_for_file: await_only_futures, avoid_print, use_build_context_synchronously, unnecessary_brace_in_string_interps, unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'main.dart';

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

// WebViewPlusController? webViewPlusController;
// Unused WebViewController, might be used later

class _WebAppState extends State<WebApp> {
  @override
  Widget build(BuildContext context) {
    String? httpState;
    if (isHTTPS == true) {
      httpState = "https";
    } else {
      httpState = "http";
    }

    if (hubport!.isEmpty || hubport == null) {
      if (httpState == "http") {
        hubport = '80';
      } else if (hubport == "https") {
        hubport = '443';
      }
    }

    hubip = hubip!.trim(); // remove whitespace

    // Disables active errors
    setState(() {
      showIPError = false;
      showPortError = false;
    });

    return Scaffold(
        resizeToAvoidBottomInset:
            false, // Make keyboard overlay instead of pushing the screen
        body: SafeArea(
            child: WebViewPlus(
          gestureNavigationEnabled: true,
          initialUrl: '${httpState}://${hubip}:${hubport}',
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: {
            JavascriptChannel(
                name: 'goBack',
                onMessageReceived: (JavascriptMessage message) async {
                  if (message.message == 'goBackToIPscreen') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                })
          },
          onWebResourceError: (error) async {
            print(await error.description);
            print(await error.failingUrl);

            int failingPort = Uri.parse(await error.failingUrl!).port;
            if (await error.description == 'net::ERR_UNSAFE_PORT') {
              setState(() {
                showPortError = true;
                portFieldErrorText =
                    'The selected port is unsafe. Please change the port.';
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (failingPort != 703 &&
                await error.description == 'net::ERR_NAME_NOT_RESOLVED') {
              setState(() {
                showIPError = true;
                ipFieldErrorText =
                    'Hub is unreachable. Please check network connection or IP.';
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else {
              setState(() {
                showIPError = true;
                ipFieldErrorText =
                    'Hub is unreachable. Please try double checking the IP and Port.';
              });
              print(
                  'WebView Load URL Error: ${await error.description} for URL: ${httpState}://${hubip}:${hubport}');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          },
        )));
  }
}
