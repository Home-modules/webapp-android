// ignore_for_file: prefer_const_constructors, camel_case_types, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, sort_child_properties_last, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'main.dart';
import 'webview.dart';

// Init Device Controls (not used)
const platform = MethodChannel('com.homemodules/device-controls');
Future<void> getMsg() async {
  try {
    print(await platform.invokeMethod('getMessage'));
  } on PlatformException catch (e) {
    print(e.message);
  }
}

// Global stuff
late TextEditingController ipController;
late TextEditingController portController;
// Might be changed later
bool isThisFirstLoad = false;
bool isThisSecondLoad = false;
// Styling Vars
Radius inputfieldBorderOutter = Radius.circular(8);
Radius inputfieldBorderInner = Radius.circular(0);
EdgeInsets inputIPpadding =
    EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 0);
EdgeInsets inputPORTpadding =
    EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5);

// idk
int? phoneScreenWidth;
int? phoneScreenHeight;

// idk v2
int? contentWidth;
// Used for Checkbox stuff
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

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
    ipController = TextEditingController();
    portController = TextEditingController();
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    phoneScreenWidth = MediaQuery.of(context).size.width.toInt();
    phoneScreenHeight = MediaQuery.of(context).size.height.toInt();
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    String theme = brightness == Brightness.dark ? 'dark' : 'light';
    BoxDecoration? boxDecoration;
    if (theme == 'dark') {
      boxDecoration = BoxDecoration(
        color: Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
          ),
        ],
      );
    } else if (theme == 'light') {
      boxDecoration = BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
          ),
        ],
      );
    }
    // print(
    //    'Screen Height: ${phoneScreenHeight}px, phone screen width: ${phoneScreenWidth}px');

    loadStorage();
    getHTTPS();
    getHubIp();
    getHubPort();
    getMsg();
    if (isThisFirstLoad == false && isThisSecondLoad == false) {
      setState(() {
        isHTTPS = isHTTPS;
        portController.text = hubport ?? '';
        ipController.text = hubip ?? '';
      });
      isThisFirstLoad = true;
    } else if (isThisSecondLoad == false && isThisFirstLoad == true) {
      setState(() {
        isHTTPS = isHTTPS;
        portController.text = hubport ?? '';
        ipController.text = hubip ?? '';
      });
      isThisFirstLoad = true;
      isThisSecondLoad = true;
    } else {}
    print(
        'hubip: ${hubip} , hubport: ${hubport}, isHTTPS: ${isHTTPS}, hubip text: ${ipController.text}');
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.color,
        color: Colors.red,
      ),
      width: min(phoneScreenWidth! - 30, 400),
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // overlays keyboards instead of pushing the screen
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Where is the hub?',
                      style: TextStyle(fontSize: 40, fontFamily: 'RobotoBold'),
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DecoratedBox(
                decoration: boxDecoration!,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Hub IP'),
                                        HubIPinput(),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Hub Port'),
                                        HubPORTinput(),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    isHTTPSinput(),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Text('Use HTTPS'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: GObutton(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HubIPinput extends StatefulWidget {
  const HubIPinput({super.key});

  @override
  State<HubIPinput> createState() => HubIPinputState_();
}

class HubIPinputState_ extends State<HubIPinput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: inputfieldBorderOutter,
                  bottomLeft: inputfieldBorderOutter,
                  bottomRight: inputfieldBorderInner,
                  topRight: inputfieldBorderInner)),
          //labelText: 'Hub IP',
          hintText: 'Enter Hub IP',
          errorMaxLines: 3,
          errorText: showIPError ? ipFieldErrorText : null,

          //icon: Icon(Icons.account_tree_sharp),
          // iconColor: Colors.blueAccent,
        ),
        controller: ipController,
        autocorrect: false,
        onSubmitted: (String value) async {
          hubip = value;
        },
      ),
    );
  }
}

class HubPORTinput extends StatefulWidget {
  const HubPORTinput({super.key});

  @override
  State<HubPORTinput> createState() => _HubPORTinputState();
}

class _HubPORTinputState extends State<HubPORTinput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topRight: inputfieldBorderOutter,
                  bottomRight: inputfieldBorderOutter,
                  bottomLeft: inputfieldBorderInner,
                  topLeft: inputfieldBorderInner),
            ),
            //labelText: 'Hub Port',
            hintText: 'Enter Hub Port',
            hintStyle: TextStyle(fontSize: 15),
            errorMaxLines: 4,
            errorText: showPortError ? portFieldErrorText : null,
          ),
          controller: portController,
          keyboardType: TextInputType.number,
          onSubmitted: (String value) {
            hubport = value;
          },
        ));
  }
}

class isHTTPSinput extends StatefulWidget {
  const isHTTPSinput({super.key});

  @override
  State<isHTTPSinput> createState() => _isHTTPSinputState();
}

class _isHTTPSinputState extends State<isHTTPSinput> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isHTTPS,
      onChanged: (value) {
        isHTTPS = value;
        setPrefs();
        setState(() {
          value = isHTTPS;
        });
      },
    );
  }
}

class GObutton extends StatefulWidget {
  const GObutton({super.key});

  @override
  State<GObutton> createState() => _GObuttonState();
}

class _GObuttonState extends State<GObutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(4, 100, 255, 1),
          borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          hubip = ipController.text;
          hubport = portController.text;
          setPrefs();
          if (ipController.text.isEmpty || ipController.text.trim() == '') {
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
    );
  }
}
