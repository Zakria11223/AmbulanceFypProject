import 'package:ambulance_app/components/buttons/action_button.dart';
import 'package:ambulance_app/components/common_app_bar.dart';
import 'package:ambulance_app/constants.dart';
import 'package:ambulance_app/model/Person.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/screens/user_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatefulWidget {
  static String id = "call_screen";
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Person args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: commonAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35.0,
                      child: Icon(
                        Icons.account_circle,
                        size: 70.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          args.getName(),
                          style: GoogleFonts.mcLaren(
                            color: kMainThemeColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Ambulance",
                          style: GoogleFonts.mcLaren(
                            color: kMainThemeColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Click Here for Any Emergency",
                style:
                    GoogleFonts.mcLaren(color: kMainThemeColor, fontSize: 16.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(
                      textLabel: "Call",
                      iconName: Icons.add_ic_call,
                      func: () => launch("tel://" + args.getContact()),
                    ),
                    ActionButton(
                      textLabel: "Direction",
                      iconName: Icons.directions_outlined,
                      func: () {
                        launch("https://www.google.com/maps/place/" +
                            args.getLocation().getLatitude().toString() +
                            "+" +
                            args.getLocation().getLongitude().toString());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Ambulance Available",
                style:
                    GoogleFonts.mcLaren(color: kMainThemeColor, fontSize: 16.0),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "24",
                      style: GoogleFonts.mcLaren(
                        color: kMainThemeColor,
                        fontSize: 100.0,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            ".",
                            style: GoogleFonts.mcLaren(
                              color: Colors.green,
                              fontSize: 80.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Hours",
                            style: GoogleFonts.mcLaren(
                              color: kMainThemeColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Material(
                color: kMainThemeColor,
                child: InkWell(
                  onTap: () async {
                    Position position = await Geolocator.getCurrentPosition();
                    print(args.getLocation());
                    print("\n\n\n");

                    FirebaseFirestore.instance.collection('RescueRides').add({
                      'name': Provider.of<UserValues>(context, listen: false)
                          .getUserName(),
                      'userUID': Provider.of<UserValues>(context, listen: false)
                          .getUserUID(),
                      'driverUID': args.getUID(),
                      'isCompleted': false,
                      'userContact':
                          Provider.of<UserValues>(context, listen: false)
                              .getUserContact(),
                      'userLocation':
                          GeoPoint(position.latitude, position.longitude),
                      'time': DateTime.now()
                    });
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Ambulance Hired",
                      buttons: [],
                      style: AlertStyle(
                        alertBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: kMainThemeColor, width: 5.0),
                        ),
                      ),
                    ).show();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    args.setHired(true);
                    Navigator.popAndPushNamed(context, UserMainScreen.id,
                        arguments: args);
                  },
                  splashColor: Colors.blue,
                  child: Center(
                    child: Text(
                      "Hired",
                      style: GoogleFonts.mcLaren(
                          fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
