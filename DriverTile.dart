import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class DriverTile extends StatelessWidget {
  final IconData icon;
  final String heading;
  final Function onTap;
  final String time;
  DriverTile({this.icon, this.heading, this.onTap, this.time});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      splashColor: kMainThemeColor,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Icon(
                icon,
                size: 80.0,
                color: kMainThemeColor,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.topLeft,
                    child: Center(
                      child: Text(
                        heading,
                        style: GoogleFonts.mcLaren(
                            fontSize: 30.0,
                            color: kMainThemeColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        maxLines: 5,
                      ),
                    ),
                  ),
                  Text(
                    "Location Updated ",
                    style: GoogleFonts.mcLaren(color: kMainThemeColor),
                  ),
                  Text(
                    time.toString() + " ago",
                    style: GoogleFonts.mcLaren(color: kMainThemeColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
