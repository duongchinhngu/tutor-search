import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';

import '../tutor_wrapper.dart';

class CompletedRequestUpdateScreen extends StatefulWidget {
  @override
  _CompletedRequestUpdateScreenState createState() =>
      _CompletedRequestUpdateScreenState();
}

class _CompletedRequestUpdateScreenState
    extends State<CompletedRequestUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            //welcome title
            Container(
              padding: EdgeInsets.only(top: 110, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 30,
                    color: Colors.greenAccent[700],
                  ),
                  Text(
                    'Request Update Successfully!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: textGreyColor,
                        fontSize: headerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //illustration image
            Container(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 20,
              ),
              child: Image.asset(
                'assets/images/flat-system-update-illustration_108061-430.jpg',
                height: 280,
              ),
            ),
            //explanation text field
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: 30,
              ),
              child: Text(
                'Your Update status is Pending!\nManager will verify your new information soon!',
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // navigating to My Course button
            InkWell(
              onTap: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  return Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => TutorBottomNavigatorBar(
                              selectedIndex: 3,
                            )),
                    ModalRoute.withName('/Home'),
                  );
                });
              },
              child: Container(
                width: 263,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: textWhiteColor,
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: textWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
