import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserValues extends ChangeNotifier {
  String _userUID = "12";
  String _userName = "Users Id";
  String _userEmail = "@gmail.com";
  String _userContact = "0303";
  String _lastDriverUID = "value";
  Position _position;
  void updateUserUID(String uid) {
    _userUID = uid;
    notifyListeners();
  }

  void updateLocation(Position pos) {
    _position = pos;
  }

  void updateUserEmail(String value) {
    _userEmail = value;
    notifyListeners();
  }

  void updateLastDriverUID(String uid) {
    _lastDriverUID = uid;
    notifyListeners();
  }

  void updateUserContact(String contact) {
    _userContact = contact;
    notifyListeners();
  }

  void updateUserName(String a) {
    _userName = a;
  }

  Position getPosition() {
    return _position;
  }

  String getUserName() {
    return _userName;
  }

  String getUserContact() {
    return _userContact;
  }

  String getUserUID() {
    return _userUID;
  }

  String getEmail() {
    return _userEmail;
  }

  String getLastDriverUID() {
    return _lastDriverUID;
  }
}
