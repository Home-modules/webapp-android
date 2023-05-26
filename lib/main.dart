import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() => runApp(const MyApp());
String? hubip;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: 250,
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Hub IP',
            hintText: 'Enter Hub IP Address',
            hintStyle: TextStyle(fontSize: 15),
            icon: Icon(Icons.account_tree_sharp),
            iconColor: Colors.blueAccent,
          ),
          controller: _controller,
          onSubmitted: (String value) async {
            hubip = value;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WebApp()),
            );
            /*await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Test Pop-up'),
                  content: Text(
                      'You typed "$value", which has length ${value.characters.length}.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            */
          },
        ),
      ),
    ));
  }
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('http://$hubip\:3000');
    return Scaffold(
        body: SafeArea(
            child: WebViewPlus(
      initialUrl: 'http://$hubip\:3000',
      javascriptMode: JavascriptMode.unrestricted,
    )));
  }
}
