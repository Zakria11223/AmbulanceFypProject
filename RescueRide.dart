import 'package:ambulance_app/model/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RescueRide {
  String _userUID;
  String _driverUID;
  String _userContact;
  gLocation _userLocation;
  Timestamp _time;
  String _userName;
  RescueRide(String a, String b, String c, gLocation d, Timestamp t, String n) {
    _userUID = a;
    _driverUID = b;
    _userContact = c;
    _userLocation = d;
    _time = t;
    _userName = n;
  }

  void setTime(Timestamp t) {
    _time = t;
  }

  Timestamp getTime() {
    return _time;
  }

  void setUserName(String t) {
    _userName = t;
  }

  String getUserName() {
    return _userName;
  }

  void setUserUID(String uid) {
    _userUID = uid;
  }

  void setDriverUID(String uid) {
    _driverUID = uid;
  }

  void setUserContact(String contact) {
    _userContact = contact;
  }

  void setUserLocation(gLocation loc) {
    _userLocation = loc;
  }

  String getUserUID() {
    return _userUID;
  }

  String getDriverUID() {
    return _driverUID;
  }

  String getUserContact() {
    return _userContact;
  }

  gLocation getUserLocation() {
    return _userLocation;
  }
}
