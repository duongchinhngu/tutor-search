import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_profile/tutee_processing_update_profile_screen.dart';


Tutee tuteeinfoupdate = Tutee.constructor(authorizedTutee.id, '', '', '',
    authorizedTutee.email, '', '', 'Active', 4, '', '');

File avatartUpdate;

TextEditingController genderupdateController =
    TextEditingController(text: authorizedTutee.gender);

TextEditingController fullnameController =
    TextEditingController(text: authorizedTutee.fullname);

TextEditingController phoneUpdateController =
    TextEditingController(text: authorizedTutee.phone);

TextEditingController addressUpdateController =
    TextEditingController(text: authorizedTutee.address);

TextEditingController birthdayUpdateController =
    TextEditingController(text: authorizedTutee.birthday);

class UpdateTuteeProfile extends StatefulWidget {
  @override
  _UpdateTuteeProfileState createState() => _UpdateTuteeProfileState();
}

class _UpdateTuteeProfileState extends State<UpdateTuteeProfile> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: buildDefaultCloseButton(context),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                //show confirm dialog here
                //'Your update would be verified! please wait a minute!'
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TuteeUpdateProfileProcessingScreen(
                      tutee: tuteeinfoupdate,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.blue[900]),
                  ),
                  child: Center(
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                          color: Colors.blue[900], fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Column(
              children: [
                //avatar
                GestureDetector(
                  onTap: () async {
                    // ignore: deprecated_member_use
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      avatartUpdate = image;
                    });
                  },
                  child: Container(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        //circle blue box behind the circle avatar
                        Container(
                          height: 175,
                          width: 175,
                          decoration: BoxDecoration(
                            // color: Colors.blue[500].withOpacity(0.35),
                            shape: BoxShape.circle,
                          ),
                        ),
                        //avartar
                        CircleAvatar(
                          foregroundColor: Colors.green,
                          radius: 80,
                          backgroundImage: avatartUpdate != null
                              ? FileImage(
                                  avatartUpdate,
                                )
                              : NetworkImage(
                                  //         // state.tutor.avatarImageLink,
                                  authorizedTutee.avatarImageLink),
                        ),
                        //edit avartar icon
                        Positioned(
                          bottom: 15,
                          right: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                // color: Colors.blue[500].withOpacity(0.35),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: textGreyColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //
                //fullname
                buildTutorInfo(
                    'Fullname',
                    Container(
                      height: 43,
                      child: TextFormField(
                        controller: fullnameController,
                        maxLength: 100,
                        textAlign: TextAlign.start,
                        onChanged: (context) {
                          setState(() {
                            // course.name = courseNameController.text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '',
                          labelStyle: textStyle,
                          fillColor: Color(0xffF9F2F2),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.0),
                          ),
                          hintText: 'What should we call you',
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: textFontSize,
                          ),
                        ),
                        validator: RequiredValidator(errorText: " is required"),
                      ),
                    ),
                    Icons.person_outline),
                _buildDivider(),
                //email
                buildTutorInfo(
                    'Email', Text(authorizedTutee.email), Icons.email),
                _buildDivider(),
                //gender
                buildTutorInfo(
                  'Gender',
                  InkWell(
                    onTap: () {
                      //
                      showBottomUpSelector(context,
                          [GENDER_MALE, GENDER_FEMALE], genderupdateController);
                    },
                    child: Container(
                      height: 40,
                      width: 60,
                      margin: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        right: 100,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            offset: Offset(1, 1),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            genderupdateController.text,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: textGreyColor,
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: mainColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  Icons.gesture,
                ),
                _buildDivider(),
                //birthday
                buildTutorInfo(
                    'Birthday',
                    InkWell(
                      onTap: () async {
                        DateTime selectedDate = await showDatePicker(
                        context: context,
                        // currentDate: defaultDatetime,
                        initialDate: DateTime(1999, 01, 01, 0, 0, 0),
                        firstDate: DateTime(1910, 01, 01, 0, 0, 0),
                        lastDate: DateTime.now(),
                      );
                      //
                      print('this is date birth');
                      setState(() {
                        birthdayUpdateController.text = selectedDate.toString().substring(0,10);
                      });
                      },
                      child: Container(
                        height: 40,
                        width: 60,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          right: 100,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              birthdayUpdateController.text,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: textGreyColor,
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    Icons.cake),
                _buildDivider(),
                //phone
                buildTutorInfo(
                    'Phone',
                    Container(
                      height: 43,
                      child: TextFormField(
                        controller: phoneUpdateController,
                        maxLength: 100,
                        textAlign: TextAlign.start,
                        onChanged: (context) {
                          //set name = value of this textFormfield on change
                          setState(() {
                            // course.name = courseNameController.text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '',
                          labelStyle: textStyle,
                          fillColor: Color(0xffF9F2F2),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.0),
                          ),
                          hintText: '',
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: textFontSize,
                          ),
                        ),
                        validator: RequiredValidator(errorText: "is required"),
                      ),
                    ),
                    Icons.phone_android_outlined),
                _buildDivider(),
                //address
                buildTutorInfo(
                    'Address',
                    Container(
                      height: 120,
                      child: TextFormField(
                        controller: addressUpdateController,
                        expands: true,
                        maxLength: 500,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        onChanged: (context) {
                          //set name = value of this textFormfield on change
                          setState(() {
                            // course.name = courseNameController.text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '',
                          labelStyle: textStyle,
                          fillColor: Color(0xffF9F2F2),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.0),
                          ),
                          hintText: 'Where are you living',
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: textFontSize,
                          ),
                        ),
                        validator: RequiredValidator(errorText: " is required"),
                      ),
                    ),
                    Icons.home_outlined),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //tutor info element
  Container buildTutorInfo(String title, Widget content, IconData icon) {
    return Container(
      child: ListTile(
          leading: Container(
            // margin: EdgeInsets.symmetric(
            //   horizontal: 20,
            // ),
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: mainColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          subtitle: content),
    );
  }

  // this will be shown when press
  Future<dynamic> showBottomUpSelector(BuildContext context, List<String> list,
      TextEditingController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Visibility(
                  visible: list[index] == controller.text,
                  child: Icon(
                    Icons.check,
                    color: mainColor,
                    size: 15,
                  ),
                ),
                title: Text(
                  list[index],
                  style: TextStyle(
                    color: list[index] == controller.text
                        ? mainColor
                        : textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  //pop
                  Navigator.pop(context);
                  //set value
                  setState(() {
                    controller.text = list[index];
                  });
                },
              );
            },
          );
        });
  }
}

Widget editForm(String hint, TextInputType inputType, int maxlengthInput,
    TextEditingController _textFieldController, String currentText) {
  return Container(
    height: 90,
    margin: EdgeInsets.only(top: 0),
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                  ),
                  height: 30,
                  width: 400,
                  child: TextField(
                    onChanged: (text) {
                      currentText = text;
                    },
                    controller: _textFieldController,
                    keyboardType: inputType,
                    maxLength: maxlengthInput,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: hint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget editFormAddress(String hint, TextInputType inputType, int maxlengthInput,
    TextEditingController _textFieldController, String currentText) {
  return Container(
    height: 150,
    margin: EdgeInsets.only(top: 0),
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                  ),
                  height: 60,
                  width: 450,
                  child: TextField(
                    onChanged: (text) {
                      currentText = text;
                    },
                    controller: _textFieldController,
                    keyboardType: inputType,
                    maxLength: maxlengthInput,
                    decoration: InputDecoration(
                      hintText: hint,
                      fillColor: textGreyColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

//divider
Divider _buildDivider() {
  return Divider(
    indent: 30,
    endIndent: 20,
  );
}
