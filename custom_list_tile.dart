import 'package:ambulance_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;
  CustomListTile({this.icon, this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: kMainThemeColor, width: 2.0)),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: kMainThemeColor,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: kMainThemeColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: GoogleFonts.mcLaren(
                            fontSize: 16.0, color: kMainThemeColor),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                  color: kMainThemeColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
