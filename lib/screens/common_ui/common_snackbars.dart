import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';

//default custom snackbar
SnackBar buildDefaultSnackBar(
  IconData snackBarIcon,
  String snackBarTitle,
  String snackBarContent,
  Color snackBarThemeColor,
) {
  return SnackBar(
    duration: Duration(
      seconds: 15,
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    elevation: 0.0,
    content: Stack(
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: snackBarThemeColor,
              boxShadow: [boxShadowStyle]),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
            color: backgroundColor,
          ),
          height: 65,
          child: ListTile(
            leading: SizedBox(
              width: 40,
              child: Icon(
                snackBarIcon,
                color: snackBarThemeColor,
                size: 30,
              ),
            ),
            title: Text(
              snackBarTitle,
              style: TextStyle(
                color: snackBarThemeColor,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              snackBarContent,
              style: textStyle,
            ),
          ),
        ),
      ],
    ),
  );
}
