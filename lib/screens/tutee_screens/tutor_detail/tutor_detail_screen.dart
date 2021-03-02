import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';

class TutorDetails extends StatefulWidget {
  @override
  _TutorDetailsState createState() => _TutorDetailsState();
}

class _TutorDetailsState extends State<TutorDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Container(
                        width: 130,
                        height: 130,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                            color: Colors.white),
                        child: FlutterLogo(),
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
                          "Nguyen Trung Huy",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/starsmall.png'),
                          Image.asset('assets/images/starsmall.png'),
                          Image.asset('assets/images/starsmall.png'),
                          Image.asset('assets/images/starsmall.png'),
                          Image.asset('assets/images/starsmall.png'),
                        ],
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
                            // BoxShadow(
                            //   color: Colors.grey.withOpacity(0.02),
                            //   spreadRadius: 5,
                            //   blurRadius: 7,
                            //   offset: Offset(0, 3), // changes position of shadow
                            // ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 230, 0, 0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "\"An essay is a focused piece of writing that develops an argument or narrative based on evidence, analysis and interpretation. There are many types of essays you might write as a student. The content and length of an essay depends on your level, subject of study, and course requirements.\"",
                              style: TextStyle(
                                color: textGreyColor,
                                fontSize: 11,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
