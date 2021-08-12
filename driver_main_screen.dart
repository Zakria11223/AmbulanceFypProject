import 'package:ambulance_app/components/UserTile.dart';
import 'package:ambulance_app/components/common_app_bar.dart';
import 'package:ambulance_app/components/custom_list_tile.dart';
import 'package:ambulance_app/constants.dart';
import 'package:ambulance_app/model/RescueRide.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/screens/RideCompleted.dart';
import 'package:ambulance_app/screens/selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Help.dart';

class DriverMainScreen extends StatefulWidget {
  static String id = "driver_main_screen";
  @override
  _DriverMainScreenState createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  String returnMinuteDifference(Timestamp time) {
    List<String> timeDuration = [
      "seconds",
      "minutes",
      "hours",
      "days",
      "month"
    ];
    List<int> timeValue = [60, 60, 24, 7, 4];
    DateTime newValue = DateTime.now();
    var oldValue = DateTime.parse(time.toDate().toString());
    int value = newValue.difference(oldValue).inSeconds;
    int counter = 0;
    while (value > timeValue[counter]) {
      value = (value / 60).round();
      counter += 1;
    }
    return value.toString() + " " + timeDuration[counter];
  }

  @override
  Widget build(BuildContext context) {
    final List<RescueRide> rides = ModalRoute.of(context).settings.arguments;
    return rides.length == 0
        ? Scaffold(
            appBar: commonAppBar(),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    accountEmail: Text(
                      Provider.of<UserValues>(context, listen: false)
                          .getEmail(),
                      style: GoogleFonts.mcLaren(fontSize: 17.3),
                    ),
                    decoration: BoxDecoration(color: kMainThemeColor),
                  ),
                  CustomListTile(
                      icon: Icons.person, label: "Profile", onTap: () {}),
                  CustomListTile(
                      icon: Icons.help_outline_outlined,
                      label: "Help & Support",
                      onTap: () {}),
                  CustomListTile(
                      icon: Icons.settings, label: "Settings", onTap: () {}),
                  CustomListTile(
                    icon: Icons.logout,
                    label: "Logout",
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, MainScreen.id, (route) => false);
                    },
                  ),
                ],
              ),
            ),
            body: Text(
              "No Active Rides",
              style:
                  GoogleFonts.mcLaren(fontSize: 16.0, color: kMainThemeColor),
            ),
          )
        : Scaffold(
            appBar: commonAppBar(),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    accountEmail: Text(
                      Provider.of<UserValues>(context, listen: false)
                          .getEmail(),
                      style: GoogleFonts.mcLaren(fontSize: 17.3),
                    ),
                    decoration: BoxDecoration(color: kMainThemeColor),
                  ),
                  CustomListTile(
                      icon: Icons.person, label: "Profile", onTap: () {}),
                  CustomListTile(
                      icon: Icons.help_outline_outlined,
                      label: "Help & Support",
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => Policy()));
                      }),
                  CustomListTile(
                      icon: Icons.settings, label: "Settings", onTap: () {}),
                  CustomListTile(
                    icon: Icons.logout,
                    label: "Logout",
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, MainScreen.id, (route) => false);
                    },
                  ),
                ],
              ),
            ),
            body: rides.length != 0
                ? ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20.0),
                    children: List.generate(rides.length, (index) {
                      return Center(
                        child: UserTile(
                            time:
                                returnMinuteDifference(rides[index].getTime()),
                            loc: rides[index].getUserLocation(),
                            heading: rides[index].getUserName(),
                            onTap: () {
                              Navigator.pushNamed(context, RideCompleted.id,
                                  arguments: rides[index]);
                            }),
                      );
                    }),
                  )
                : Text(
                    "No Active Rides",
                    style: GoogleFonts.mcLaren(),
                  ),
          );
  }
}
