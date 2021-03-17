import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_profile/update_tutee_profile_screen.dart';

class TuteeProfileManagement extends StatefulWidget {
  final IconData snackBarIcon;
  final String snackBarTitle;
  final String snackBarContent;
  final Color snackBarThemeColor;

  const TuteeProfileManagement(
      {Key key,
      this.snackBarIcon,
      this.snackBarTitle,
      this.snackBarContent,
      this.snackBarThemeColor})
      : super(key: key);

  @override
  _TuteeProfileManagementState createState() => _TuteeProfileManagementState();
}

class _TuteeProfileManagementState extends State<TuteeProfileManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: buildDefaultBackButton(context),
      // ),
      body: Container(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: mainColor,
                ),
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 60, 0, 0),
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                            // state.tutor.avatarImageLink,
                            'http://www.gstatic.com/tv/thumb/persons/528854/528854_v9_bb.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(140, 60, 0, 0),
                child: Column(
                  children: [
                    Container(
                      child: Container(
                        width: 200,
                        height: 40,
                        child: Text(
                          authorizedTutee.fullname,
                          style: TextStyle(
                              color: textWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 20,
                      child: Text(
                        authorizedTutee.email,
                        style: TextStyle(
                          color: textWhiteColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
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
                        width: 210,
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Courses",
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "125",
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Reviews",
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "176",
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateTuteeProfile(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 195, 0, 0),
                  child: Container(
                    height: 35,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.blue[900]),
                    ),
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 230),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 30),
                      child: Column(
                        children: [
                          Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: textGreyColor, width: 1))),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 90,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset('assets/images/gender.png'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  'Gender',
                                                  style: TextStyle(
                                                      color: textGreyColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  authorizedTutee.gender,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 7),
                                    width: 150,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: textGreyColor,
                                                width: 1))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Image.asset(
                                              'assets/images/birthday-cake.png'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  'Birthday',
                                                  style: TextStyle(
                                                      color: textGreyColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                    authorizedTutee.birthday,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: textGreyColor, width: 1))),
                            child: Container(
                              width: 180,
                              height: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child:
                                        Image.asset('assets/images/phone.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 37),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Text(
                                            'Phone',
                                            style: TextStyle(
                                              color: textGreyColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          child: Text(
                                            authorizedTutee.phone,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: textGreyColor, width: 1))),
                            child: Container(
                              width: 180,
                              height: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                        'assets/images/pinlocation.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 37),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Text(
                                            'Address',
                                            style: TextStyle(
                                              color: textGreyColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          child: Text(
                                            authorizedTutee.address,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: textGreyColor, width: 1))),
                            child: Container(
                              width: 180,
                              height: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                        'assets/images/history.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 37),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Text(
                                            'Transaction',
                                            style: TextStyle(
                                              color: textGreyColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          child: Text(
                                            '68 Transactions',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
