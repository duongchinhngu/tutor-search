import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/screens/common_ui/common_popups.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_register_screens/tutee_register_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_register_screens/tutee_register_variables.dart';
import 'tutor_register_screen.dart' as tutor_screen;
import 'tutor_register_variables.dart';

//text input field
Container buildInputField(
    String title,
    String hintext,
    TextInputType textInputType,
    MultiValidator validators,
    TextEditingController controller) {
  return Container(
    width: 260,
    height: 60,
    child: TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      keyboardType: textInputType,
      onChanged: (context) {},
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          color: mainColor,
          fontSize: titleFontSize,
        ),
        isDense: true,
        fillColor: backgroundColor,
        filled: true,
        focusedBorder: InputBorder.none,
        counterText: '',
        border: UnderlineInputBorder(
            borderSide: BorderSide(
          color: mainColor,
          width: 1,
        )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: mainColor,
          width: 0,
        )),
        hintText: hintext,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: textFontSize,
        ),
      ),
      validator: validators,
    ),
  );
}

Container buildInputPhoneUpdateField(
    String title,
    String currentphone,
    TextInputType textInputType,
    MultiValidator validators,
    TextEditingController controller) {
  return Container(
    width: 260,
    height: 60,
    child: TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      keyboardType: textInputType,
      onChanged: (context) {},
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          color: mainColor,
          fontSize: titleFontSize,
        ),
        isDense: true,
        fillColor: backgroundColor,
        filled: true,
        focusedBorder: InputBorder.none,
        counterText: '',
        border: UnderlineInputBorder(
            borderSide: BorderSide(
          color: mainColor,
          width: 1,
        )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: mainColor,
          width: 0,
        )),
      ),
      validator: validators,
    ),
  );
}

class OnPressableInputDateField extends StatefulWidget {
  String title;
  final TextEditingController controller;
  final List<dynamic> bottomUpList;
  final double widthLength;

  OnPressableInputDateField({
    Key key,
    this.title,
    this.controller,
    this.bottomUpList,
    this.widthLength,
  }) : super(key: key);
  @override
  _OnPressableInputDateFieldState createState() =>
      _OnPressableInputDateFieldState();
}

class _OnPressableInputDateFieldState extends State<OnPressableInputDateField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //if not datetime or time selector, show list in bottom up
        if (widget.bottomUpList != null) {
          showBottomUpSingleSelector(context, widget.bottomUpList);
        } else {
          //set selected birthay
          // selectedBirthday = await
          DateTime selectedDate = await dateSelector(context, selectedBirthday);
          //set value to register tutee obj
          setState(() {
            registerTutee.birthday = convertDayTimeToString(selectedDate);
            // this.widget.title = registerTutee.birthday;
            this.widget.controller.text = registerTutee.birthday;
          });
          // registerTutee.birthday = convertDayTimeToString(selectedDate);

          //
          // birthdayController.text = registerTutee.birthday;
        }
        //
      },
      child: Container(
        width: widget.widthLength != null ? widget.widthLength : 260,
        height: 60,
        child: TextFormField(
          controller: widget.controller,
          textAlign: TextAlign.start,
          enabled: false,
          decoration: InputDecoration(
            labelText: this.widget.title,
            labelStyle: TextStyle(
              color: mainColor,
              fontSize: titleFontSize,
            ),
            isDense: true,
            fillColor: backgroundColor,
            filled: true,
            focusedBorder: InputBorder.none,
            counterText: '',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
              color: mainColor,
              width: 1,
            )),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
              width: 0,
            )),
            errorStyle: TextStyle(
              color: Colors.red,
              // fontSize: 8,
            ),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: mainColor,
              width: 0,
            )),
          ),
          validator: RequiredValidator(errorText: 'is required!'),
        ),
      ),
    );
  }

  Future<dynamic> showBottomUpSingleSelector(
      BuildContext context, List<dynamic> list) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Visibility(
                  visible: list[index] == registerTutee.gender,
                  child: Icon(
                    Icons.check,
                    color: mainColor,
                    size: 15,
                  ),
                ),
                title: Text(
                  list[index],
                  style: TextStyle(
                    color: list[index] == registerTutee.gender
                        ? mainColor
                        : textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  //pop
                  Navigator.pop(context);
                  //set value
                  if (widget.title == 'Gender') {
                    registerTutee.gender = list[index];
                    //
                    genderController.text = registerTutee.gender;
                  }
                },
              );
            },
          );
        });
  }
}

//ontapable( can press) to select a bottom up value
//look like a textfield but it can be filled by keyboard
//text input field
class OnPressableInputField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final List<dynamic> bottomUpList;
  final double widthLength;

  const OnPressableInputField({
    Key key,
    @required this.title,
    @required this.controller,
    this.bottomUpList,
    this.widthLength,
  }) : super(key: key);
  @override
  _OnPressableInputFieldState createState() => _OnPressableInputFieldState();
}

class _OnPressableInputFieldState extends State<OnPressableInputField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //if not datetime or time selector, show list in bottom up
        if (widget.bottomUpList != null) {
          showBottomUpSingleSelector(context, widget.bottomUpList);
        } else if (widget.title.contains('day')) {
          //set selected birthay
          // selectedBirthday = await
          DateTime selectedDate = await dateSelector(context, selectedBirthday);
          //set value to register tutee obj
          registerTutee.birthday = convertDayTimeToString(selectedDate);
          //
          birthdayController.text = registerTutee.birthday;
        }
        //
      },
      child: Container(
        width: widget.widthLength != null ? widget.widthLength : 260,
        height: 60,
        child: TextFormField(
          controller: widget.controller,
          textAlign: TextAlign.start,
          enabled: false,
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: TextStyle(
              color: mainColor,
              fontSize: titleFontSize,
            ),
            isDense: true,
            fillColor: backgroundColor,
            filled: true,
            focusedBorder: InputBorder.none,
            counterText: '',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
              color: mainColor,
              width: 1,
            )),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
              width: 0,
            )),
            errorStyle: TextStyle(
              color: Colors.red,
              // fontSize: 8,
            ),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: mainColor,
              width: 0,
            )),
          ),
          validator: RequiredValidator(errorText: 'is required!'),
        ),
      ),
    );
  }

//study form bottom up
//select study form;
// this will be shown when press studyform
  Future<dynamic> showBottomUpSingleSelector(
      BuildContext context, List<dynamic> list) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Visibility(
                  visible: list[index] == registerTutee.gender,
                  child: Icon(
                    Icons.check,
                    color: mainColor,
                    size: 15,
                  ),
                ),
                title: Text(
                  list[index],
                  style: TextStyle(
                    color: list[index] == registerTutee.gender
                        ? mainColor
                        : textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  //pop
                  Navigator.pop(context);
                  //set value
                  if (widget.title == 'Gender') {
                    registerTutee.gender = list[index];
                    //
                    genderController.text = registerTutee.gender;
                  }
                },
              );
            },
          );
        });
  }
}

// --------------for tutor--------------------

//ontapable( can press) to select a bottom up value
//look like a textfield but it can be filled by keyboard
//text input field
class OnPressableTutorInputField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final List<dynamic> bottomUpList;
  final double widthLength;

  const OnPressableTutorInputField({
    Key key,
    @required this.title,
    @required this.controller,
    this.bottomUpList,
    this.widthLength,
  }) : super(key: key);
  @override
  _OnPressableTutorInputFieldState createState() =>
      _OnPressableTutorInputFieldState();
}

class _OnPressableTutorInputFieldState
    extends State<OnPressableTutorInputField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //if not datetime or time selector, show list in bottom up
        if (widget.title == 'Gender') {
          showBottomUpGenderSelector(context, widget.bottomUpList);
        } else if (widget.title.contains('day')) {
          //set selected birthay
          // selectedBirthday = await
          DateTime selectedDate = await dateSelector(context, selectedBirthday);
          //set value to register tutee obj
          registerTutor.birthday = convertDayTimeToString(selectedDate);
          //
          tutor_screen.birthdayController.text = registerTutor.birthday;
        } else if (widget.title == 'Education Level') {
          showBottomUpEducationLevelSelector(context, widget.bottomUpList);
        }
        //
      },
      child: Container(
        width: widget.widthLength != null ? widget.widthLength : 260,
        height: 60,
        child: TextFormField(
          controller: widget.controller,
          textAlign: TextAlign.start,
          enabled: false,
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: TextStyle(
              color: mainColor,
              fontSize: titleFontSize,
            ),
            isDense: true,
            fillColor: backgroundColor,
            filled: true,
            focusedBorder: InputBorder.none,
            counterText: '',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
              color: mainColor,
              width: 1,
            )),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
              width: 0,
            )),
            errorStyle: TextStyle(
              color: Colors.red,
              // fontSize: 8,
            ),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: mainColor,
              width: 0,
            )),
          ),
          validator: RequiredValidator(errorText: 'is required!'),
        ),
      ),
    );
  }

  // this will be shown when press
  Future<dynamic> showBottomUpEducationLevelSelector(
      BuildContext context, List<dynamic> list) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Visibility(
                  visible: list[index] == registerTutor.educationLevel,
                  child: Icon(
                    Icons.check,
                    color: mainColor,
                    size: 15,
                  ),
                ),
                title: Text(
                  list[index],
                  style: TextStyle(
                    color: list[index] == registerTutor.educationLevel
                        ? mainColor
                        : textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  //pop
                  Navigator.pop(context);
                  //set value
                  registerTutor.educationLevel = list[index];
                  //
                  tutor_screen.educationLevelController.text =
                      registerTutor.educationLevel;
                },
              );
            },
          );
        });
  }

// this will be shown when press
  Future<dynamic> showBottomUpGenderSelector(
      BuildContext context, List<dynamic> list) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Visibility(
                  visible: list[index] == registerTutor.gender,
                  child: Icon(
                    Icons.check,
                    color: mainColor,
                    size: 15,
                  ),
                ),
                title: Text(
                  list[index],
                  style: TextStyle(
                    color: list[index] == registerTutor.gender
                        ? mainColor
                        : textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  //pop
                  Navigator.pop(context);
                  //set value
                  if (widget.title == 'Gender') {
                    registerTutor.gender = list[index];
                    //
                    tutor_screen.genderController.text = registerTutor.gender;
                  }
                },
              );
            },
          );
        });
  }
}
