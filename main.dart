import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/screens/Help.dart';
import 'package:ambulance_app/screens/RideCompleted.dart';
import 'package:ambulance_app/screens/call_screen.dart';
import 'package:ambulance_app/screens/direction_screen.dart';
import 'package:ambulance_app/screens/driver_main_screen.dart';
import 'package:ambulance_app/screens/forgot_password_screen.dart';
import 'package:ambulance_app/screens/list_screen.dart';
import 'package:ambulance_app/screens/personnal_info_screen.dart';
import 'package:ambulance_app/screens/user_main_screen.dart';
import 'package:ambulance_app/screens/selection_screen.dart';
import 'package:ambulance_app/screens/signin_screen.dart';
import 'package:ambulance_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'loading_screens/main_loading_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserValues(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rescue 1122',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: MainLoadingScreen.id,
      routes: {
        MainLoadingScreen.id: (context) => MainLoadingScreen(),
        MainScreen.id: (context) => MainScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        UserMainScreen.id: (context) => UserMainScreen(),
        DriverMainScreen.id: (context) => DriverMainScreen(),
        CallScreen.id: (context) => CallScreen(),
        ListScreen.id: (context) => ListScreen(),
        RideCompleted.id: (context) => RideCompleted(),
        PersonnalInfoScreen.id: (context) => PersonnalInfoScreen(),
        DirectionScreen.id: (context) => DirectionScreen(),
        DirectionScreen.id: (context) => Policy(),
      },
    );
  }
}
