import 'package:ambulance_app/components/buttons/action_button.dart';
import 'package:ambulance_app/components/common_app_bar.dart';
import 'package:ambulance_app/model/RescueRide.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/model/location.dart';
import 'package:ambulance_app/screens/direction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'driver_main_screen.dart';

class RideCompleted extends StatefulWidget {
  static String id = "ride_completed_screen";
  @override
  _RideCompletedState createState() => _RideCompletedState();
}

class _RideCompletedState extends State<RideCompleted> {
  @override
  Widget build(BuildContext context) {
    final RescueRide ride = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: commonAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  ride.getUserName(),
                  style: GoogleFonts.mcLaren(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: kMainThemeColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionButton(
                        textLabel: "Call",
                        iconName: Icons.add_ic_call,
                        func: () => launch("tel://" + ride.getUserContact()),
                      ),
                      ActionButton(
                        textLabel: "Direction",
                        iconName: Icons.directions_outlined,
                        func: () {
                          Navigator.pushNamed(context, DirectionScreen.id,
                              arguments: ride);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Material(
            color: kMainThemeColor,
            child: InkWell(
              onTap: () async {
                String documentID;
                final user = await FirebaseFirestore.instance
                    .collection('RescueRides')
                    .where('isCompleted', isEqualTo: false)
                    .get();
                for (var d in user.docs) {
                  if (d.data()['driverUID'] == ride.getDriverUID() &&
                      d.data()['userUID'] == ride.getUserUID()) {
                    setState(() {
                      documentID = d.id;
                    });
                  }
                }
                FirebaseFirestore.instance
                    .collection('RescueRides')
                    .doc(documentID)
                    .update({
                  'isCompleted': true,
                });
                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Ride Completed",
                  buttons: [],
                  style: AlertStyle(
                    alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: kMainThemeColor, width: 5.0),
                    ),
                  ),
                ).show();
                List<RescueRide> rides = [];
                final dataset = await FirebaseFirestore.instance
                    .collection('RescueRides')
                    .where('isCompleted', isEqualTo: false)
                    .get();
                for (var dataValue in dataset.docs) {
                  if (dataValue.data()['driverUID'] ==
                      Provider.of<UserValues>(context, listen: false)
                          .getUserUID()) {
                    rides.add(RescueRide(
                        dataValue.data()['userUID'],
                        dataValue.data()['driverUID'],
                        dataValue.data()['userContact'],
                        gLocation(dataValue.data()['userLocation'].latitude,
                            dataValue.data()['userLocation'].longitude),
                        dataValue.data()['time'],
                        dataValue.data()['name']));
                  }
                }
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, DriverMainScreen.id,
                    arguments: rides);
              },
              splashColor: Colors.blue,
              child: Center(
                child: Text(
                  "Ride Completed",
                  style:
                      GoogleFonts.mcLaren(fontSize: 40.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
