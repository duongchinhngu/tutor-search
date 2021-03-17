import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_search_system/commons/colors.dart';
import '../global_variables.dart' as globals;

//convert timeofday type to string value
String convertTimeOfDayToString(TimeOfDay time) {
  return globals.timeFormatter
      .format(new DateTime(1990, 1, 1, time.hour, time.minute, 0));
}

//convert timeOfDay type to string
// has format : yyyy-MM-ddThh:mm
// the same format as backend format
String convertTimeOfDayToAPIFormatString(TimeOfDay time) {
  return globals.defaultDatetime +
      'T' +
      globals.timeFormatter
          .format(new DateTime(1990, 1, 1, time.hour, time.minute, 0));
}

//convert DateTime type to string value
String convertDayTimeToString(DateTime date) {
  return globals.dateFormatter.format(date);
}

//select image from storage
Future<File> getImageFromGallery() async {
  // ignore: deprecated_member_use
  return await ImagePicker.pickImage(source: ImageSource.gallery);
}

//select image from taking picture
Future<File> getImageFromCamera() async {
  // ignore: deprecated_member_use
  return await ImagePicker.pickImage(source: ImageSource.camera);
}

//get status and return proper color for the status
Color mapStatusToColor(String status) {
  if (status == globals.CourseConstants.DENIED_STATUS) {
    return deniedColor;
  } else if (status == globals.CourseConstants.ACTIVE_STATUS ||
      status == globals.CourseConstants.ACCEPTED_STATUS) {
    return activeColor;
  } else if (status == globals.CourseConstants.PENDING_STATUS) {
    return pendingColor;
  }
  //this is error color for test
  return Colors.tealAccent;
}

//get year old from birthday
int getYearOldFromBithdayString(String birthday) {
  return DateTime.now().year - int.parse(birthday.substring(0, 4));
}
