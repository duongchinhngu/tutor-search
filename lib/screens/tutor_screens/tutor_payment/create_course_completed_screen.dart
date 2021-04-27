import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_wrapper.dart';

class CreateCourseCompletedScreen extends StatefulWidget {
  @override
  _CreateCourseCompletedScreenState createState() =>
      _CreateCourseCompletedScreenState();
}

class _CreateCourseCompletedScreenState
    extends State<CreateCourseCompletedScreen> {
  final FirebaseMessaging fcm = FirebaseMessaging();
  @override
  void initState() {
    //
    super.initState();
    fcm.getToken().then((token) {
      print(token);
    });
    //
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        //
        final snackBar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: null,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
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
                    'Create Course Completed!',
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
                'assets/images/reading-concept-isometric-books-reading-people-illustration-study-free-time-entertainment-with-books-education-isometric-library-with-encyclopedia-learn_80590-8731.jpg',
                width: 300,
                height: 300,
              ),
            ),
            //explanation text field
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: 30,
              ),
              child: Text(
                'Your course status is Pending now!\nManager will accept your course soon!',
                style: TextStyle(
                  fontSize: textFontSize,
                  color: Colors.grey,
                ),
              ),
            ),
            // navigating to My Course button
            InkWell(
              onTap: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  return Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => TutorBottomNavigatorBar()),
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
                        Icons.library_books_rounded,
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
                          'My Course',
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
