import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
void loadPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    loadPrefs();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 33, 71, 92),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Color.fromARGB(255, 4, 4, 4),
        primaryColor: Colors.lightBlue[800],
      ),
      home: HomePage(),
    );
  }
}

// final String? hubip = prefs.getString('action');
String? hubip;
String? hubport;
bool? isHTTPS = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blueAccent;
      }
      return Colors.blueAccent;
    }

    return Scaffold(
        // backgroundColor: Colors.black,
        body: Center(
            child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Hub IP',
                hintText: 'Enter Hub IP',
                hintStyle: TextStyle(fontSize: 15),
                //icon: Icon(Icons.account_tree_sharp),
                // iconColor: Colors.blueAccent,
              ),
              controller: _controller,
              onSubmitted: (String value) async {
                hubip = value;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WebApp()),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: SizedBox(
            width: 130,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Hub Port',
                hintText: 'Enter Hub Port',
                hintStyle: TextStyle(fontSize: 15),
              ),
              controller: myController,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 120),
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isHTTPS,
            onChanged: (bool? value) {
              isHTTPS = value;
              setState(() {
                isHTTPS = value!;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: const Text('Is server HTTPS?'),
        ),
        Center(
          child: SizedBox(
            width: 130,
            child: ElevatedButton(
              child: Text('Go'),
              onPressed: () {
                hubip = _controller.text;
                hubport = myController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WebApp()),
                );
              },
            ),
          ),
        )
      ],
    )));
  }
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? httpState;
    if (isHTTPS == true)
      httpState = "https";
    else
      httpState = "http";
    print('${httpState}://${hubip}:${hubport}');
    return Scaffold(
        body: SafeArea(
            child: WebViewPlus(
      initialUrl: '${httpState}://${hubip}:${hubport}',
      javascriptMode: JavascriptMode.unrestricted,
    )));
  }
}
