// ignore_for_file: must_be_immutable

import 'package:chatroom/constants/colors.dart';
import 'package:chatroom/constants/const_functions.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  InputWidget({
    Key? key,
    required this.text,
    required this.txt,
    required this.error,
    this.opacity = true,
    this.pswd = false,
    this.opacityValue = 0.5,
    this.borderColorBlack = false,
    this.autofocus = false,
    this.fontSize = 20,
    required this.theme,
    required this.title,
    required this.titleletterSpacing,
  }) : super(key: key);

  String text;
  TextEditingController txt;
  bool error;
  bool opacity;
  bool pswd;
  double opacityValue;
  bool borderColorBlack;
  double fontSize;
  bool autofocus;
  DarkTheme theme;
  String title;
  double titleletterSpacing;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.005 * width),
                border: Border.all(
                    color: error
                        ? Colors.transparent
                        : borderColorBlack
                            ? theme.surfaceBlack
                            : theme.labelWhite)),
            child: TextField(
              obscureText: pswd,
              autofocus: autofocus,
              scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              controller: txt,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              style: urbanist(borderColorBlack ? theme.surfaceBlack : theme.labelWhite, fontsize: 0.016 * width),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.012 * width, vertical: 0.02 * height),
                hintText: text,
                hintStyle: urbanist(opacity ? theme.labelWhite.withOpacity(opacityValue) : theme.labelWhite, fontsize: 0.016 * width),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                errorText: error ? "Check Input" : null,
                errorStyle: urbanist(Colors.red, weight: FontWeight.bold, fontsize: 0.008 * width),
              ),
            )),
      ],
    );
  }
}
