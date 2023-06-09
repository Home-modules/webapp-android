// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'main.dart';
import 'webview.dart';

// Global stuff
late TextEditingController textController;
late TextEditingController myController;

Radius inputfieldBorderOutter = Radius.circular(8);
Radius inputfieldBorderInner = Radius.circular(3);

EdgeInsets inputIPpadding =
    EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 30);
EdgeInsets inputPORTpadding =
    EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 15);

int? phoneScreenWidth;
int? phoneScreenHeight;
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
    textController = TextEditingController();
    myController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    phoneScreenWidth = MediaQuery.of(context).size.width.toInt();
    phoneScreenHeight = MediaQuery.of(context).size.height.toInt();
    // print(
    //    'Screen Height: ${phoneScreenHeight}px, phone screen width: ${phoneScreenWidth}px');
    getHTTPS();
    getHubIp();
    getHubPort();
    setState(() {
      isHTTPS = isHTTPS;
      myController.text = hubport ?? '';
      textController.text = hubip ?? '';
    });
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // overlays keyboards instead of pushing the screen
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center, //
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: inputIPpadding,
                  child: HubIPinput(),
                ),
                Padding(
                  padding: inputPORTpadding,
                  child: HubPORTinput(),
                ),
              ],
            )
          ],
        ));
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
          labelText: 'Hub IP',
          hintText: 'Enter Hub IP',
          errorMaxLines: 3,
          errorText: showIPError ? ipFieldErrorText : null,
          //icon: Icon(Icons.account_tree_sharp),
          // iconColor: Colors.blueAccent,
        ),
        controller: textController,
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
            labelText: 'Hub Port',
            hintText: 'Enter Hub Port',
            hintStyle: TextStyle(fontSize: 15),
            errorMaxLines: 4,
            errorText: showPortError ? portFieldErrorText : null,
          ),
          controller: myController,
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
      value: true,
      onChanged: (value) {
        setState(() {
          value = !value!;
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
    return ElevatedButton(
      child: Text('Go'),
      onPressed: () {
        hubip = textController.text;
        hubport = myController.text;
        setPrefs();
        if (textController.text.isEmpty) {
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
    );
  }
}
