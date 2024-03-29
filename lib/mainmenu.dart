// ignore_for_file: prefer_const_constructors, camel_case_types, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, sort_child_properties_last, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'main.dart';
import 'webview.dart';

isNumeric(string) => num.tryParse(string) != null;

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
EdgeInsets inputPadding =
    EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0);

// Used to determine the maximum width
int? phoneScreenWidth;
int? phoneScreenHeight;
void skiptoWebAppF(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WebApp()),
  );
}

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (skiptowebapp! && alreadyWebApp == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WebApp()),
        );

        alreadyWebApp =
            true; // prevent infinite back and forth if webapp fetching fails
      }
    });
  }

  @override
  void dispose() {
    if (alreadyWebApp) {
    } else {
      ipController.dispose();
      portController.dispose();
    }
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

    // I don't think following code is even required
    loadStorage();
    getHTTPS();
    getHubIp();
    getHubPort();
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
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.color,
        color: Colors.red,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // overlays keyboards instead of pushing the screen
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Where is the hub?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40, fontFamily: 'RobotoBold'),
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: min(phoneScreenWidth! - 30, 400),
                child: DecoratedBox(
                  decoration: boxDecoration!,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("IP Address"),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: HubIPinput(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Port"),
                                  HubPORTinput(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [isHTTPSinput(), Text('Use HTTPS')],
                          ),
                        ),
                        GObutton()
                      ],
                    ),
                  ),
                ),
              ),
            )
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
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: inputfieldBorderOutter,
                bottomLeft: inputfieldBorderOutter,
                bottomRight: inputfieldBorderInner,
                topRight: inputfieldBorderInner)),
        //labelText: 'Hub IP',
        hintText: 'Enter IP',
        errorMaxLines: 3,
        errorText: showIPError ? ipFieldErrorText : null,
        contentPadding: inputPadding,
        //icon: Icon(Icons.account_tree_sharp),
        // iconColor: Colors.blueAccent,
      ),
      controller: ipController,
      autocorrect: false,
      onSubmitted: (String value) async {
        hubip = value;
      },
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
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topRight: inputfieldBorderOutter,
              bottomRight: inputfieldBorderOutter,
              bottomLeft: inputfieldBorderInner,
              topLeft: inputfieldBorderInner),
        ),
        //labelText: 'Hub Port',
        hintText: 'Enter Port',
        hintStyle: TextStyle(fontSize: 15),
        errorMaxLines: 4,
        contentPadding: inputPadding,
        errorText: showPortError ? portFieldErrorText : null,
      ),
      controller: portController,
      keyboardType: TextInputType.number,
      onSubmitted: (String value) {
        hubport = value;
      },
    );
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
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.pressed)) {
                return Color.fromRGBO(4, 100, 255, 1);
              }
              if (states.contains(MaterialState.hovered)) {
                return Color.fromRGBO(3, 83, 216, 1); // rgb(3, 83, 216)
              }
              return Color.fromRGBO(4, 100, 255, 1);
            }),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(20.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
          ),
          child: Text(
            'Continue',
            style: TextStyle(fontSize: 25, fontFamily: 'RobotoBold'),
          ),
          onPressed: () {
            hubip = ipController.text;
            hubport = portController.text;
            setPrefs();
            if (ipController.text.isEmpty ||
                ipController.text.trim() == '' ||
                ipController.text == null) {
              setState(() {
                showIPError = true;
                ipFieldErrorText = 'IP address cannot be empty';
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WebApp()),
              );
            }
          },
        ));
  }
}
