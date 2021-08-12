import 'package:ambulance_app/components/buttons/login_button.dart';
import 'package:ambulance_app/components/input/login_input.dart';
import 'package:ambulance_app/model/Person.dart';
import 'package:ambulance_app/model/RescueRide.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/screens/driver_main_screen.dart';
import 'package:ambulance_app/screens/personnal_info_screen.dart';
import 'package:ambulance_app/screens/user_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:ambulance_app/model/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import 'package:ambulance_app/screens/forgot_password_screen.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  static String id = 'sign_in_screen';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showSpinner = false;

  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  String email;
  String password;

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
        inAsyncCall: showSpinner,
        child: Stack(
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
                  "Login",
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
                SizedBox(
                  height: 10.0,
                ),
                LoginButton(
                  icon: Text("Sign In"),
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
                      showSpinner = true;
                    });
                    try {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.bestForNavigation);
                      Provider.of<UserValues>(context, listen: false)
                          .updateLocation(position);
                      final user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);
                      if (user != null) {
                        Provider.of<UserValues>(context, listen: false)
                            .updateUserUID(user.user.uid);
                        Provider.of<UserValues>(context, listen: false)
                            .updateUserEmail(email);
                        final userRole = await FirebaseFirestore.instance
                            .collection('users')
                            .where('uid', isEqualTo: user.user.uid)
                            .get();
                        for (var value in userRole.docs) {
                          if (value.data()['isFirstLogin'] == true) {
                            if (value.data()['role'] == 'user') {
                              Navigator.pushNamed(
                                  context, PersonnalInfoScreen.id,
                                  arguments: true);
                            } else {
                              Navigator.pushNamed(
                                  context, PersonnalInfoScreen.id,
                                  arguments: false);
                            }
                          } else {
                            final dataSet = await FirebaseFirestore.instance
                                .collection('Preson')
                                .where('uid', isEqualTo: user.user.uid)
                                .get();
                            for (var dat in dataSet.docs) {
                              Provider.of<UserValues>(context, listen: false)
                                  .updateUserName(dat.data()['name']);
                              Provider.of<UserValues>(context, listen: false)
                                  .updateUserEmail(dat.data()['email']);
                              Provider.of<UserValues>(context, listen: false)
                                  .updateUserContact(dat.data()['contact']);
                            }
                            if (value.data()['role'] == 'user') {
                              Navigator.pushNamed(context, UserMainScreen.id,
                                  arguments: Person.simplePlayer());
                            } else {
                              List<RescueRide> rides = [];
                              final dataset = await FirebaseFirestore.instance
                                  .collection('RescueRides')
                                  .where('isCompleted', isEqualTo: false)
                                  .get();
                              for (var dataValue in dataset.docs) {
                                if (dataValue.data()['driverUID'] ==
                                    Provider.of<UserValues>(context,
                                            listen: false)
                                        .getUserUID()) {
                                  rides.add(RescueRide(
                                      dataValue.data()['userUID'],
                                      dataValue.data()['driverUID'],
                                      dataValue.data()['userContact'],
                                      gLocation(
                                          dataValue
                                              .data()['userLocation']
                                              .latitude,
                                          dataValue
                                              .data()['userLocation']
                                              .longitude),
                                      dataValue.data()['time'],
                                      dataValue.data()['name']));
                                }
                              }
                              Navigator.pushNamed(context, DriverMainScreen.id,
                                  arguments: rides);
                            }
                          }
                        }
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Wrong Password",
                          buttons: [],
                          style: AlertStyle(
                            alertBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: kMainThemeColor, width: 5.0),
                            ),
                          ),
                        ).show();
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  value: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: kMainThemeColor),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ForgotPasswordScreen.id);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
