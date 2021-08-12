import 'package:ambulance_app/constants.dart';
import 'package:ambulance_app/model/RescueRide.dart';
import 'package:ambulance_app/model/UserValues.dart';
import 'package:ambulance_app/model/assistantMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DirectionScreen extends StatefulWidget {
  static String id = "direction_screen";
  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> pLineSet = {};

  var showData;

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Circle circle;
  GoogleMapController _controller;
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
    final RescueRide ride = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation(
                Provider.of<UserValues>(context, listen: false).getPosition()),
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
              Position pos = Position(latitude: 33.6694, longitude: 72.9972);
              getPlaceDirection(pos);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Distance : " + showData.distanceText.toString(),
                  style: GoogleFonts.mcLaren(
                      color: kMainThemeColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Duration : " + showData.durationText.toString(),
                  style: GoogleFonts.mcLaren(
                      color: kMainThemeColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
