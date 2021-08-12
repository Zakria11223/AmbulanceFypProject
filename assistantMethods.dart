import 'package:ambulance_app/constants.dart';
import 'package:ambulance_app/model/directionDetails.dart';
import 'package:ambulance_app/model/requestAssitant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssistantMehthods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$MAPS_API_KEY";
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }

  static Future<DirectionDetail> obtainPlaceDirectionDetails(
      LatLng source, LatLng destination) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$MAPS_API_KEY";
    var response = await RequestAssistant.getRequest(directionUrl);
    if (response == "failed") {
      return null;
    }
    DirectionDetail directionDetail = DirectionDetail();
    directionDetail.encodedPoints =
        response["routes"][0]["overview_polyline"]["points"];
    directionDetail.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetail.distanceValue =
        response["routes"][0]["legs"][0]["distance"]["value"];
    directionDetail.durationText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetail.durationValue =
        response["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetail;
  }
}
