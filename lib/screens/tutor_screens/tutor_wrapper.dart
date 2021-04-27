import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/screens/common_ui/notification_screens/notification_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/create_course_screens/create_course_welcome.dart';
import 'package:tutor_search_system/screens/tutor_screens/report_revenue/report_revenue_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_courses_screens/tutor_my_course_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_profile/tutor_profile_screen.dart';

class TutorBottomNavigatorBar extends StatefulWidget {
  final selectedIndex;

  const TutorBottomNavigatorBar({Key key, this.selectedIndex})
      : super(key: key);

  @override
  _TutorBottomNavigatorBarState createState() =>
      _TutorBottomNavigatorBarState();
}

class _TutorBottomNavigatorBarState extends State<TutorBottomNavigatorBar> {
  int _currentIndex = 0;
  var screens = [];

  @override
  void initState() {
    super.initState();
    //reset token
    getFCMToken().then((token) {
      AccountRepository().resetFCMToken(authorizedTutor.email, token);
    });
    //init screen tab navigation bar
    screens = [
      TutorMyCourseScreen(),
      CreateCourseWelcomeScreen(),
      NotificationScreen(
        receiverEmail: authorizedTutor.email,
      ),
      TutorProfileScreen(
        tutor: authorizedTutor,
      ),
      ReportRevenueScreen(),
    ];
    if (widget.selectedIndex != null) {
      _currentIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.black38,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home),
          //   title: Text('Home'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('Course'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Notification'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            title: Text('Revenue Report'),
          ),
        ],
      ),
    );
  }
}
