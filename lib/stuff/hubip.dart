// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import '../main.dart';

class HubIPinput extends StatefulWidget {
  const HubIPinput({super.key});

  @override
  State<HubIPinput> createState() => HubIPinputState_();
}

class HubIPinputState_ extends State<HubIPinput> {
  static late TextEditingController textController;
  Radius inputfieldBorderOutter = Radius.circular(8);
  Radius inputfieldBorderInner = Radius.circular(3);

  EdgeInsets inputspadding =
      EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5);
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
    );
  }
}
