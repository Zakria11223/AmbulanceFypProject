import 'package:ambulance_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Widget icon;
  final Function onPressedFunction;
  final bool value;
  LoginButton({this.icon, this.onPressedFunction, this.value});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200.0,
      child: FlatButton(
        padding: EdgeInsets.all(20.0),
        child: icon,
        onPressed: onPressedFunction,
        color: value ? kMainThemeColor : Colors.white,
        textColor: value ? Colors.white : kMainThemeColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: kMainThemeColor)),
      ),
    );
  }
}
