// ignore next line:

// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, avoid_print, await_only_futures, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainmenu.dart';
import 'webview.dart';

// Used as settings
String? hubip;
String? hubport;
String? username;
String? password;
bool? isHTTPS = false;
bool? skiptowebapp = false;
bool alreadyWebApp = false;
// Used for error handling
bool showPortError = false;
String? portFieldErrorText;
bool showIPError = false;
String? ipFieldErrorText;
var prefs;

Future<void> loadStorage() async {
  prefs = await SharedPreferences.getInstance();
}

Future<bool> getHTTPS() async {
  isHTTPS = (await prefs.getBool('isHTTPS')) ?? false;
  return isHTTPS!;
}

Future<String> getHubIp() async {
  hubip = await prefs.getString('hubip') ?? '';
  return hubip!;
}

Future<String> getHubPort() async {
  if (await prefs.getString('hubport') == null)
    skiptowebapp = false;
  else
    skiptowebapp = true;
  hubport = await prefs.getString('hubport') ?? '80';
  return hubport!;
}

Future setPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isHTTPS', isHTTPS!);
  prefs.setString('hubip', hubip!);
  prefs.setString('hubport', hubport!);
}

Future<void> initializeApp() async {
  await loadStorage();
  getHubIp();
  getHubPort();
  getHTTPS();
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // function name suggests what it does
  await initializeApp();
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
        // primaryColor: const Color.fromARGB(255, 33, 71, 92),
        scaffoldBackgroundColor: Color.fromRGBO(245, 245, 245, 1),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromRGBO(19, 19, 20, 1),
        primaryColor: Colors.lightBlue[800],
      ),
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
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (skiptowebapp! && alreadyWebApp == false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WebApp()),
          );
          alreadyWebApp = true;
        }
      });
    }

    initState();
    return MainMenu();
  }
}
