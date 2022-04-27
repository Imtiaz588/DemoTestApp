import 'package:flutter/material.dart';

class Constants{

  static final primaryColor = Colors.lightBlue[200];
  static final primaryButtonStyle = ElevatedButton.styleFrom(
    primary: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  );

  static const simpleTextStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Colors.black54);

  static final boldTextStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: primaryColor);
}