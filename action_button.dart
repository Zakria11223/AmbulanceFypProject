import 'package:flutter/material.dart';
import 'package:ambulance_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
  final String textLabel;
  final IconData iconName;
  final Function func;
  ActionButton({this.textLabel, this.iconName, this.func});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          ClipOval(
            child: Material(
              color: kMainThemeColor,
              child: InkWell(
                splashColor: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    iconName,
                    size: 70.0,
                    color: Colors.white,
                  ),
                ),
                onTap: func,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            textLabel,
            style: GoogleFonts.mcLaren(
                color: kMainThemeColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
