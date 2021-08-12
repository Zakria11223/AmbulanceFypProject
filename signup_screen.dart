import 'package:ambulance_app/components/buttons/login_button.dart';
import 'package:ambulance_app/components/input/login_input.dart';
import 'package:ambulance_app/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:get/get.dart';
import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  static String id = "sign_up_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

enum Role { user, driver }

class _SignUpScreenState extends State<SignUpScreen> {
  //final _auth = FirebaseAuth.instance;

  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  var confirmPasswordTextController = TextEditingController();

  String confirmPassword;
  String email;
  String password;

  bool showSpinner = false;

  Role _role = Role.user;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: kMainThemeColor,
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
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
                "Sign Up",
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
                  controller: emailTextController,
                  obsecureText: false,
                  hint: "Enter your email ",
                  onChangedFunction: (newValue) {
                    email = newValue;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
                child: InputField(
                  input: TextInputType.text,
                  controller: passwordTextController,
                  obsecureText: true,
                  hint: "Enter your password ",
                  onChangedFunction: (newValue) {
                    password = newValue;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
                child: InputField(
                  input: TextInputType.text,
                  controller: confirmPasswordTextController,
                  obsecureText: true,
                  hint: "Confirm Password ",
                  onChangedFunction: (newValue) {
                    confirmPassword = newValue;
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ListTile(
                title: Text(
                  'User',
                  style: kSignUpTextStyle,
                ),
                leading: Radio<Role>(
                  activeColor: kMainThemeColor,
                  value: Role.user,
                  groupValue: _role,
                  onChanged: (Role value) {
                    setState(() {
                      _role = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Driver',
                  style: kSignUpTextStyle,
                ),
                leading: Radio<Role>(
                  value: Role.driver,
                  activeColor: kMainThemeColor,
                  groupValue: _role,
                  onChanged: (Role value) {
                    setState(() {
                      _role = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              LoginButton(
                icon: Text("Sign Up"),
                onPressedFunction: () async {
                  setState(() {
                    if (password == null || password.isEmpty) {
                      return Get.defaultDialog(
                        title: 'Fill Form',
                        cancelTextColor: Colors.white,
                        buttonColor: Colors.white,
                        content: Text(
                          'Please enter your email and password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red[900],
                        confirmTextColor: Colors.white,
                        onCancel: () {},
                        barrierDismissible: false,
                      );
                    }
                    else if (password == confirmPassword) {
                      showSpinner = true;
                    }
                  });
                  if (password == confirmPassword) {
                    try {
                      final newUser = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        if (_role == Role.user) {
                          FirebaseFirestore.instance.collection('users').add({
                            'email': email,
                            'role': 'user',
                            'uid': newUser.user.uid.toString()
                          });
                          Navigator.pushNamed(context, SignInScreen.id);
                        } else {
                          FirebaseFirestore.instance.collection('users').add({
                            'email': email,
                            'role': 'driver',
                            'isFirstLogin': true,
                            'uid': newUser.user.uid.toString()
                          });
                          emailTextController.clear();
                          passwordTextController.clear();
                          Navigator.pushNamed(context, SignInScreen.id);
                        }
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Try Again",
                      desc: "Passwords Mismatch",
                      buttons: [],
                      style: AlertStyle(
                        alertBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: kMainThemeColor, width: 5.0),
                        ),
                      ),
                    ).show();
                  }
                },
                value: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
