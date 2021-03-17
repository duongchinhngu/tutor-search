import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_profile/tutee_processing_update_profile_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_register_screens/register_elements.dart';

String _origingender = authorizedTutee.gender;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildDefaultCloseButton(context),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
              onTap: () {
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
                //Containner Avarta
                // Container(
                //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                //   child: CircleAvatar(
                //     radius: 65,
                //     backgroundImage: NetworkImage(
                //         // state.tutor.avatarImageLink,
                //         'http://www.gstatic.com/tv/thumb/persons/528854/528854_v9_bb.jpg'),
                //   ),

                // )
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
                                  'http://www.gstatic.com/tv/thumb/persons/528854/528854_v9_bb.jpg'),
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

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: textGreyColor, width: 1))),
                  width: double.infinity,
                  height: 110,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                          child: Image.asset('assets/images/study.png')),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 200,
                              height: 40,
                              child: Text(
                                'Fullname',
                                style: TextStyle(color: textGreyColor),
                              )),
                          Container(
                            width: 200,
                            height: 50,
                            // child: buildInputPhoneUpdateField(
                            //     _currentphone,
                            //     authorizedTutee.phone,
                            //     TextInputType.phone,
                            //     MultiValidator([
                            //       RequiredValidator(
                            //           errorText: 'Phone is required!'),
                            //     ]),
                            //     phoneController),
                            child: editForm(
                                authorizedTutee.fullname,
                                TextInputType.text,
                                50,
                                fullnameController,
                                fullnameController.text),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: textGreyColor, width: 1))),
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                          child: Image.asset('assets/images/email.png')),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 200,
                              child: Text(
                                'Email',
                                style: TextStyle(color: textGreyColor),
                              )),
                          Container(
                              width: 200,
                              child: Text(
                                authorizedTutee.email,
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              )),
                        ],
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: textGreyColor, width: 1))),
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                          child: Image.asset('assets/images/gender.png')),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          boxShadow: [
                            boxShadowStyle,
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 150,
                                child: Text(
                                  'Gender',
                                  style: TextStyle(color: textGreyColor),
                                )),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 150,
                              // child: Text(
                              //   authorizedTutee.gender,
                              //   style: TextStyle(
                              //       color: textGreyColor,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 17),
                              // )
                              child: DropdownButton(
                                hint: _origingender == null
                                    ? Text('Dropdown')
                                    : Text(
                                        genderupdateController.text,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: TextStyle(
                                  color: mainColor,
                                ),
                                items: ['Male', 'Female'].map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      genderupdateController.text = val;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 1),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: textGreyColor, width: 1))),
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                          child:
                              Image.asset('assets/images/birthday-cake.png')),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        // margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          boxShadow: [
                            boxShadowStyle,
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 150,
                                child: Text(
                                  'Birthday',
                                  style: TextStyle(color: textGreyColor),
                                )),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 150,
                              height: 40,
                              // child: Text(
                              //   authorizedTutee.gender,
                              //   style: TextStyle(
                              //       color: textGreyColor,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 17),
                              // )

                              child: OnPressableInputDateField(
                                // title: authorizedTutee.birthday,
                                controller: birthdayUpdateController,
                                widthLength: 130,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: textGreyColor, width: 1))),
                  width: double.infinity,
                  height: 110,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                          child: Image.asset('assets/images/phone.png')),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 200,
                              height: 40,
                              child: Text(
                                'Phone',
                                style: TextStyle(color: textGreyColor),
                              )),
                          Container(
                            width: 200,
                            height: 50,
                            // child: buildInputPhoneUpdateField(
                            //     _currentphone,
                            //     authorizedTutee.phone,
                            //     TextInputType.phone,
                            //     MultiValidator([
                            //       RequiredValidator(
                            //           errorText: 'Phone is required!'),
                            //     ]),
                            //     phoneController),
                            child: editForm(
                                authorizedTutee.phone,
                                TextInputType.phone,
                                12,
                                phoneUpdateController,
                                phoneUpdateController.text),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: textGreyColor, width: 1))),
                  width: double.infinity,
                  height: 110,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                          child: Image.asset('assets/images/pinlocation.png')),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 200,
                              height: 40,
                              child: Text(
                                'Address',
                                style: TextStyle(color: textGreyColor),
                              )),
                          Container(
                            width: 200,
                            height: 50,
                            // child: buildInputPhoneUpdateField(
                            //     _currentphone,
                            //     authorizedTutee.phone,
                            //     TextInputType.phone,
                            //     MultiValidator([
                            //       RequiredValidator(
                            //           errorText: 'Phone is required!'),
                            //     ]),
                            //     phoneController),
                            child: editForm(
                                authorizedTutee.address,
                                TextInputType.multiline,
                                200,
                                addressUpdateController,
                                addressUpdateController.text),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget editForm(String hint, TextInputType inputType, int maxlengthInput,
    TextEditingController _textFieldController, String currentText) {
  // final TextEditingController _textFieldController = TextEditingController(
  //   text: content,
  // );
  return Container(
    height: 90,
    margin: EdgeInsets.only(top: 0),
    child: Column(
      children: <Widget>[
        // Expanded(
        //   flex: 2,
        //   child: Container(
        //     padding: EdgeInsets.only(left: 20),
        //     alignment: Alignment.bottomLeft,
        //   ),
        // ),
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
                  height: 45,
                  width: 350,
                  child: TextField(
                    onChanged: (text) {
                      currentText = text;
                    },
                    controller: _textFieldController,
                    keyboardType: inputType,
                    maxLength: maxlengthInput,
                    decoration: InputDecoration(
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
