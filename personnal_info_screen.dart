import 'package:ambulance_app/components/buttons/login_button.dart';
import 'package:ambulance_app/components/common_app_bar.dart';
import 'package:ambulance_app/components/input/InfoInput.dart';
import 'package:ambulance_app/model/RescueRide.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/screens/driver_main_screen.dart';
import 'package:ambulance_app/screens/user_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:ambulance_app/model/location.dart';

class PersonnalInfoScreen extends StatefulWidget {
  static String id = "personnal_info_screen";
  @override
  _PersonnalInfoScreenState createState() => _PersonnalInfoScreenState();
}

class _PersonnalInfoScreenState extends State<PersonnalInfoScreen> {
  String name;
  String contact;
  String gender;

  var nameTextController = TextEditingController();
  var contactTextController = TextEditingController();
  var genderTextController = TextEditingController();

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    final bool value = ModalRoute.of(context).settings.arguments;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: commonAppBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoInput(
                  label: "Name",
                  controller: nameTextController,
                  onChanged: (newValue) {
                    name = newValue;
                  },
                ),
                InfoInput(
                  label: "Contact",
                  controller: contactTextController,
                  onChanged: (newValue) {
                    contact = newValue;
                  },
                ),
                InfoInput(
                  label: "Gender",
                  controller: genderTextController,
                  onChanged: (newValue) {
                    gender = newValue;
                  },
                ),
                LoginButton(
                  icon: Text("Add Information"),
                  value: true,
                  onPressedFunction: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    Provider.of<UserValues>(context, listen: false)
                        .updateUserContact(contact);
                    Provider.of<UserValues>(context, listen: false)
                        .updateUserName(name);
                    final dV = await FirebaseFirestore.instance
                        .collection('users')
                        .where('uid',
                            isEqualTo:
                                Provider.of<UserValues>(context, listen: false)
                                    .getUserUID())
                        .get();
                    String documentID;
                    for (var val in dV.docs) {
                      documentID = val.id;
                    }
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(documentID)
                        .update({'isFirstLogin': false});
                    Position position = await Geolocator.getCurrentPosition();
                    FirebaseFirestore.instance.collection('Person').add({
                      'uid': Provider.of<UserValues>(context, listen: false)
                          .getUserUID(),
                      'name': name,
                      'contact': contact,
                      'gender': gender,
                      'isDriver': value ? false : true,
                      'last_location':
                          GeoPoint(position.latitude, position.longitude),
                      'time': DateTime.now()
                    });
                    if (value) {
                      Navigator.pushNamed(context, UserMainScreen.id);
                    } else {
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
                              gLocation(
                                  dataValue.data()['userLocation'].latitude,
                                  dataValue.data()['userLocation'].longitude),
                              dataValue.data()['time'],
                              dataValue.data()['name']));
                        }
                      }
                      Navigator.pushNamed(context, DriverMainScreen.id,
                          arguments: rides);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
