import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

AppBar commonAppBar() {
  return AppBar(
    centerTitle: true,
    title: Text(
      "Rescue 1122",
      style: GoogleFonts.mcLaren(),
    ),
    backgroundColor: kMainThemeColor,
  );
}
