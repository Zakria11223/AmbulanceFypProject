import 'package:ambulance_app/components/buttons/login_button.dart';
import 'package:ambulance_app/constants.dart';
import 'package:ambulance_app/screens/signin_screen.dart';
import 'package:ambulance_app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MainScreen extends StatefulWidget {
  static String id = "main_screen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.ambulance,
                size: 100.0,
                color: kMainThemeColor,
              ),
              Text(
                "Rescue 1122",
                style: TextStyle(
                    fontSize: 25.0,
                    color: kMainThemeColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40.0,
              ),
              LoginButton(
                icon: Text("Sign In"),
                onPressedFunction: () {
                  Navigator.pushNamed(context, SignInScreen.id);
                },
                value: true,
              ),
              SizedBox(
                height: 25.0,
              ),
              LoginButton(
                icon: Text("Sign Up"),
                onPressedFunction: () {
                  Navigator.pushNamed(context, SignUpScreen.id);
                },
                value: false,
              ),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ],
      )),
    );
  }
}
