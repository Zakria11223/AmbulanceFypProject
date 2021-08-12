import 'package:ambulance_app/components/common_app_bar.dart';
import 'package:ambulance_app/components/custom_list_tile.dart';
import 'package:ambulance_app/constants.dart';
import 'package:ambulance_app/model/Person.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/model/assistantMethods.dart';
import 'package:ambulance_app/screens/RideCompleted.dart';
import 'package:ambulance_app/screens/TwilioApi.dart';
import 'package:ambulance_app/screens/list_screen.dart';
import 'package:ambulance_app/screens/selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:ambulance_app/model/location.dart';
import 'package:get/get.dart';


class UserMainScreen extends StatefulWidget {
  static String id = "user_main_screen";
  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  bool showSpinner = false;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> pLineSet = {};

  var showData;

  GoogleMapController _controller;

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Circle circle;
  String address;
  CameraPosition initialLocation(Position position) {
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.2,
    );
  }

  Future<void> getPlaceDirection(Position pos) async {
    var initialPos =
    Provider.of<UserValues>(context, listen: false).getPosition();
    var finalPos = pos;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var driveLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    var details = await AssistantMehthods.obtainPlaceDirectionDetails(
        pickUpLatLng, driveLatLng);
    print("This is Encoded Points :: ");
    print(details.encodedPoints);
    print(details.durationText);
    print(details.distanceText);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
    polylinePoints.decodePolyline(details.encodedPoints);
    pLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    pLineSet.clear();
    setState(() {
      showData = details;
      Polyline polyline = Polyline(
          color: kMainThemeColor,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      pLineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > driveLatLng.latitude &&
        pickUpLatLng.longitude > driveLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: driveLatLng, northeast: driveLatLng);
    } else if (pickUpLatLng.longitude > driveLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, driveLatLng.longitude),
          northeast: LatLng(driveLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > driveLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(driveLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, driveLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: driveLatLng);
    }
    _controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: "Start", snippet: "My Location"),
      position: pickUpLatLng,
      markerId: MarkerId("PickUpID"),
    );
    Marker dropOffLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: "Drop", snippet: "Destination"),
      position: driveLatLng,
      markerId: MarkerId("DropOffID"),
    );
    Circle pickUpCircle = Circle(
      fillColor: Colors.yellow,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
      circleId: CircleId("PickUp"),
    );
    Circle dropOffCircle = Circle(
      fillColor: Colors.deepPurple,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurpleAccent,
      circleId: CircleId("Destination"),
    );
    setState(() {
      markerSet.add(pickUpLocationMarker);
      markerSet.add(dropOffLocationMarker);
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Person args = ModalRoute.of(context).settings.arguments;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: commonAppBar(),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Row(
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Text(
                      Provider.of<UserValues>(context).getUserName(),
                      style: GoogleFonts.mcLaren(
                          fontSize: 30.0, color: Colors.white),
                    )
                  ],
                ),
                accountEmail: Text(
                  Provider.of<UserValues>(context, listen: false).getEmail(),
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
                  }),
            ],
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Material(
                    color: kMainThemeColor,
                    child: InkWell(
                      onTap: () async {
                        List<Person> driver = [];
                        setState(() {
                          showSpinner = true;
                        });
                        final user = await FirebaseFirestore.instance
                            .collection('Person')
                            .get();
                        for (var userData in user.docs) {
                          if (userData.data()['isDriver'] == true) {
                            driver.add(Person(
                                userData.data()['uid'],
                                userData.data()['name'],
                                userData.data()['contact'],
                                userData.data()['gender'],
                                gLocation(
                                    userData.data()['last_location'].latitude,
                                    userData.data()['last_location'].longitude),
                                userData.data()['time']));
                          }
                        }
                        Navigator.pushNamed(context, ListScreen.id,
                            arguments: driver);
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      splashColor: Colors.blue,
                      child: Column(


                        children: [
                          Center(
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(Icons.car_repair,color: Colors.white, size: 35,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Drivers",
                                  style: GoogleFonts.mcLaren(
                                      fontSize: 28.0, color: Colors.white),
                                ),


                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: initialLocation(
                        Provider.of<UserValues>(context, listen: false)
                            .getPosition()),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    compassEnabled: true,
                    markers: markerSet,
                    circles: circleSet,
                    polylines: pLineSet,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      if (args.isHired()) {
                        Position pos = Position(
                            latitude: args.getLocation().getLatitude(),
                            longitude: args.getLocation().getLongitude());
                        getPlaceDirection(pos);
                        print("\n\n\n");
                        print(args.getLocation().getLatitude());
                        print(args.getLocation().getLongitude());
                        print("\n\n\n");
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(

                    children: [

                      Container(
                        height: 10,
                      ),

                      Material(
                        color: kMainThemeColor,
                        child: Column(
                          children: [
                            InkWell(
                              onTap:(){
                                Get.to(Twilio());
                              },
                              child: Center(
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Icon(Icons.message_outlined,color: Colors.white, size: 30,),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Quick Response",style: GoogleFonts.mcLaren(
                                        fontSize: 28.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showData == null
                        ? " "
                        : "Distance : " + showData.distanceText.toString(),
                    style: GoogleFonts.mcLaren(
                        color: kMainThemeColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    showData == null
                        ? " "
                        : "Duration : " + showData.durationText.toString(),
                    style: GoogleFonts.mcLaren(
                        color: kMainThemeColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}