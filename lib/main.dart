// ignore next line:

// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, avoid_print, await_only_futures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'webview.dart';

// Used as settings
String? hubip;
String? hubport;
bool? isHTTPS = false;
bool? skiptowebapp = false;

// Used for error handling
bool showPortError = false;
String? portFieldErrorText;
bool showIPError = false;
String? ipFieldErrorText;

Future<bool> getHTTPS() async {
  final prefs = await SharedPreferences.getInstance();
  isHTTPS = await prefs.getBool('isHTTPS') ?? false;
  return prefs.getBool('isHTTPS') ?? false;
}

Future<String> getHubIp() async {
  final prefs = await SharedPreferences.getInstance();
  hubip = await prefs.getString('hubip');
  return prefs.getString('hubip') ?? '';
}

Future<String> getHubPort() async {
  final prefs = await SharedPreferences.getInstance();
  if (await prefs.getString('hubport') == null)
    skiptowebapp = false;
  else
    skiptowebapp = true;
  hubport = await prefs.getString('hubport');
  return 'done';
}

Future setPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isHTTPS', isHTTPS!);
  prefs.setString('hubip', hubip!);
  prefs.setString('hubport', hubport!);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 33, 71, 92),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1),
        primaryColor: Colors.lightBlue[800],
      ),
      home: HomePage(),
    );
  }
}

// final String? hubip = prefs.getString('action');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller; // Hub Ip
  late TextEditingController myController; // Hub Port

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    myController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getHTTPS();
    getHubIp();
    getHubPort();
    setState(() {
      isHTTPS = isHTTPS;
      hubip = hubip;
      hubport = hubport;
      print('');
    });
    _controller.text = hubip ?? '';
    myController.text = hubport ?? '';

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
        resizeToAvoidBottomInset:
            false, // overlays keyboards instead of pushing the screen
        body: Center(
            child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hub IP',
                    hintText: 'Enter Hub IP',
                    hintStyle: TextStyle(fontSize: 15),
                    errorMaxLines: 3,
                    errorText: showIPError ? '${ipFieldErrorText}' : null,
                    //icon: Icon(Icons.account_tree_sharp),
                    // iconColor: Colors.blueAccent,
                  ),
                  controller: _controller,
                  onSubmitted: (String value) async {
                    hubip = value;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: SizedBox(
                width: 130,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hub Port',
                    hintText: 'Enter Hub Port',
                    hintStyle: TextStyle(fontSize: 15),
                    errorMaxLines: 4,
                    errorText: showPortError ? '${portFieldErrorText}' : null,
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
                  isHTTPS = value!;
                  setState(() {
                    isHTTPS = value;
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
                    setPrefs();
                    if (_controller.text.isEmpty) {
                      setState(() {
                        showIPError = true;
                        ipFieldErrorText = 'Hub IP cannot be empty';
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WebApp()),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        )));
  }
}
