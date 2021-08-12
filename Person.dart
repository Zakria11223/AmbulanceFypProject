import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'location.dart';

class Person {
  String _uid;
  String _name;
  String _contact;
  String _gender;
  gLocation _lastLocation;
  String _time;
  bool _isHired;

  void setHired(bool a) {
    _isHired = a;
  }

  bool isHired() {
    return _isHired;
  }

  Person(String uid, String name, String contact, String gender,
      gLocation location, Timestamp time,
      {bool a = false}) {
    _uid = uid;
    _name = name;
    _contact = contact;
    _gender = gender;
    _lastLocation = location;
    _time = returnMinuteDifference(time);
    _isHired = a;
  }

  Person.simplePlayer() {
    _isHired = false;
  }

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

  void setUID(String uid) {
    _uid = uid;
  }

  void setContact(String contact) {
    _contact = contact;
  }

  void setLocation(gLocation loc) {
    _lastLocation.setLatitude(loc.getLatitude());
    _lastLocation.setLongitude(loc.getLongitude());
  }

  void setName(String name) {
    _name = name;
  }

  void setGender(String gender) {
    _gender = gender;
  }

  void setTime(String time) {
    _time = time;
  }

  String getUID() {
    return _uid;
  }

  gLocation getLocation() {
    return _lastLocation;
  }

  String getContact() {
    return _contact;
  }

  String getName() {
    return _name;
  }

  String getGender() {
    return _gender;
  }

  String getTime() {
    return _time;
  }
}
