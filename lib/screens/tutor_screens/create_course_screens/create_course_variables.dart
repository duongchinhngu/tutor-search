import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:tutor_search_system/commons/common_model.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_payment/tutor_payment_screen.dart';

//this is default course (when tutor does not choose fields for new course)
//default value of unchosen field is "No Select"
Course course = Course(
  0,
  // name
  '',
  //begintime
  globals.DEFAULT_NO_SELECT,
  // endtime
  globals.DEFAULT_NO_SELECT,
  //study fee
  null,
  //days in week
  '[]',
  //begin date
  globals.DEFAULT_NO_SELECT,
  // end date
  globals.DEFAULT_NO_SELECT,
  //description
  '',
  //status
  'isDraft',
  //class has subject
  //this is hard code need to refactor
  0,
  //thi sis hard code
  //createdBy
  globals.authorizedTutor.id,
  1,
  //location
  globals.authorizedTutor.address,
  //extraImages
  '[]'
);

//course name field controller
TextEditingController courseNameController = TextEditingController();
TextEditingController courseFeeController = TextEditingController();
TextEditingController courseDescriptionController = TextEditingController();
TextEditingController courseMaxTuteeController =
    TextEditingController(text: '1');
TextEditingController locationController =
    TextEditingController(text: globals.authorizedTutor.address);

// ----course extra images-------------------
List<File> extraImages = [File('')];

//selectedClassName
String selectedClassName = globals.DEFAULT_NO_SELECT;

//this class inorder to check wether or not this field selected;
class CreateCourseItem extends SelectableObject {
  CreateCourseItem(String content, bool isSelected)
      : super(content, isSelected);
}
//class create course item

//study form create course item
CreateCourseItem _online = CreateCourseItem('Online', false);
CreateCourseItem _tutorHome = CreateCourseItem('Tutor Home', false);
//
List<CreateCourseItem> studyForms = [
  _online,
  _tutorHome,
];

//empty input fields
void resetInputFields() {
  //empty input fields
  courseNameController.clear();
  courseFeeController.clear();
  courseDescriptionController.clear();
  courseMaxTuteeController = TextEditingController(text: '1');
  locationController =
      TextEditingController(text: globals.authorizedTutor.address);
}

//reset all field of create course screen; set = empty
void resetEmptyCreateCourseScreen() {
  //reset to default values
  course = Course(
      0,
      // name
      '',
      //begintime
      globals.DEFAULT_NO_SELECT,
      // endtime
      globals.DEFAULT_NO_SELECT,
      //study fee
      null,
      //days in week
      '[]',
      //begin date
      globals.DEFAULT_NO_SELECT,
      // end date
      globals.DEFAULT_NO_SELECT,
      //description
      '',
      //status
      'isDraft',
      //class has subject
      //this is hard code need to refactor
      0,
      //thi sis hard code
      //createdBy
      globals.authorizedTutor.id,
      1,
      //location
      globals.authorizedTutor.address,
      //extraImages
      '[]');
  //reset all text controllers text = empty
  resetInputFields();
  //reset all bottom up selected value
  //
  selectedClassName = globals.DEFAULT_NO_SELECT;
  //set selectedDateRange is null
  selectedDateRange = null;
  //set selectedTimeRange is null
  selectedTimeRange = null;
  //reset use point input = null
  usePointController.clear();
  //clear list of extra images
  extraImages = [File('')];
}

//default date range ( contains beginDate and endDate)
DateTimeRange selectedDateRange;
//default date range ( contains beginDate and endDate)
TimeRange selectedTimeRange;
