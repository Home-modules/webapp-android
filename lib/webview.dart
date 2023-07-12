// ignore_for_file: await_only_futures, avoid_print, use_build_context_synchronously, unnecessary_brace_in_string_interps, unused_import, depend_on_referenced_packages, prefer_const_constructors

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:webview_flutter/webview_flutter.dart' as wem;

import 'main.dart';

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

void startTimer() {
  Timer(Duration(seconds: 5), () {
    // See if target IP is reachable
  });
}

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

    wem.WebViewController? webView;
    KeyboardVisibilityController keyboardVisibilityController =
        KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        // Scroll the field into view
        webView!.runJavascript('''
      // JavaScript code to scroll the field into view
      const activeElement = document.activeElement;
      if (activeElement) {
      activeElement.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' });
      }
    ''');
      }
    });

    return Scaffold(
        resizeToAvoidBottomInset:
            false, // Make keyboard overlay instead of pushing the screen
        body: SafeArea(
            child: wem.WebView(
          gestureNavigationEnabled: true,
          initialUrl: '${httpState}://${hubip}:${hubport}/webapp/',
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
                    'The selected port is unsafe. Please change the port';
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
                    'Hub is unreachable. Please check network connection or IP';
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (error.description == 'net::ERR_SSL_PROTOCOL_ERROR') {
              setState(() {
                showIPError = true;
                ipFieldErrorText = 'Wrongly used HTTPS';
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (error.description == 'net::ERR_CONNECTION_REFUSED') {
              setState(() {
                showIPError = true;
                ipFieldErrorText = 'Invalid port or hub isn\'t running';
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (error.description == 'net::ERR_CONNECTION_TIMED_OUT') {
              setState(() {
                showIPError = true;
                ipFieldErrorText =
                    'Hub timed out, check your netwrok connection';
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else {
              setState(() {
                showIPError = true;
                ipFieldErrorText =
                    'Hub is unreachable. Please try double checking the IP and Port or see if the hub is running';
              });
              print(
                  'WebView Load URL Error: ${await error.description} for URL: ${httpState}://${hubip}:${hubport}/webapp');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          },
          onWebViewCreated: (controller) {
            webView = controller;
            webView!.runJavascript('''
            window.flutterWrapper =  { 
              goToIPScreen() {
                if (goBack) {
                  goBack.postMessage('goBackToIPscreen');
                }
              }
            }''');
          },
        )));
  }
}
