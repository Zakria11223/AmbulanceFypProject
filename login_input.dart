import 'package:flutter/material.dart';
import 'package:ambulance_app/constants.dart';

class InputField extends StatelessWidget {
  final bool obsecureText;
  final TextInputType input;
  final Function onChangedFunction;
  final String hint;
  final controller;
  InputField({
    this.controller,
    this.input,
    this.hint,
    this.obsecureText,
    this.onChangedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: input,
      obscureText: obsecureText,
      textAlign: TextAlign.center,
      onChanged: onChangedFunction,
      decoration: kTextFieldDecoration.copyWith(hintText: hint),
    );
  }
}
