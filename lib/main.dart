// ignore next line:

// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, avoid_print, await_only_futures, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainmenu.dart';

// Used as settings
String? hubip;
String? hubport;
String? username;
String? password;
bool? isHTTPS = false;
bool? skiptowebapp = false;

// Used for error handling
bool showPortError = false;
String? portFieldErrorText;
bool showIPError = false;
String? ipFieldErrorText;
var prefs;
void loadStorage() async {
  prefs = await SharedPreferences.getInstance();
}

Future<bool> getHTTPS() async {
  prefs = await SharedPreferences.getInstance();
  isHTTPS = await prefs.getBool('isHTTPS') ?? false;
  return prefs.getBool('isHTTPS') ?? false;
}

Future<String> getHubIp() async {
  prefs = await SharedPreferences.getInstance();
  hubip = await prefs.getString('hubip');
  return prefs.getString('hubip') ?? '';
}

Future<String> getHubPort() async {
  prefs = await SharedPreferences.getInstance();
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
        scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
    loadStorage();
    return MainMenu();
  }
}
