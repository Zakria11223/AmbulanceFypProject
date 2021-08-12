class gLocation {
  double _latitude;
  double _longitude;
  gLocation(double a, double b) {
    _latitude = a;
    _longitude = b;
  }
  void setLatitude(double value) {
    _latitude = value;
  }

  void setLongitude(double value) {
    _longitude = value;
  }

  double getLatitude() {
    return _latitude;
  }

  double getLongitude() {
    return _longitude;
  }
}
