import 'package:ambulance_app/components/buttons/login_button.dart';
import 'package:ambulance_app/components/input/login_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = "forgot_password_screen";
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var newPasswordTextController = TextEditingController();
  var oldPasswordTextController = TextEditingController();
  var confirmPasswordTextController = TextEditingController();

  String oldPassword;
  String newPassword;
  String confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.ambulance,
                size: 50.0,
                color: kMainThemeColor,
              ),
              Text(
                "Rescue 1122",
                style: TextStyle(
                  fontSize: 25.0,
                  color: kMainThemeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 40.0,
                  color: kMainThemeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
                child: InputField(
                  input: TextInputType.emailAddress,
                  controller: oldPasswordTextController,
                  obsecureText: true,
                  hint: "Enter old password ",
                  onChangedFunction: (newValue) {
                    oldPassword = newValue;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
                child: InputField(
                  input: TextInputType.text,
                  controller: newPasswordTextController,
                  obsecureText: true,
                  hint: "Enter new password ",
                  onChangedFunction: (newValue) {
                    newPassword = newValue;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
                child: InputField(
                  input: TextInputType.text,
                  controller: confirmPasswordTextController,
                  obsecureText: true,
                  hint: "Confirm new password ",
                  onChangedFunction: (newValue) {
                    confirmPassword = newValue;
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              LoginButton(
                icon: Text("Submit"),
                onPressedFunction: () {},
                value: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
