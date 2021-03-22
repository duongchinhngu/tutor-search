import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_courses_screens/tutor_my_course_screen.dart';
import 'package:tutor_search_system/states/course_state.dart';

class MyCourseScreen extends StatefulWidget {
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  //default seelcted status
  String _selectedStatus = 'All';
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1.5,
        title: Text(
          'My Courses',
          style: GoogleFonts.kaushanScript(
            textStyle: TextStyle(
              color: mainColor,
              fontSize: headerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(child: buildCourseStatusCard(0, 'All')),
                  Expanded(child: buildCourseStatusCard(1, 'Accepted')),
                  Expanded(child: buildCourseStatusCard(2, 'Denied')),
                  Expanded(child: buildCourseStatusCard(3, 'Pending')),
                ],
              ),
            ),
            CourseListView(
              currentStatus: _selectedStatus,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildCourseStatusCard(int index, String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // set selected class UI
          _selectedStatus = status;
        });
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              status,
              style: TextStyle(
                color: _selectedStatus == status ? mainColor : textGreyColor,
                fontSize: titleFontSize,
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: _selectedStatus == status ? mainColor : Colors.transparent,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseListView extends StatefulWidget {
  final String currentStatus;

  const CourseListView({Key key, @required this.currentStatus})
      : super(key: key);
  @override
  _CourseListViewState createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit(CourseRepository()),
      child: BlocBuilder<CourseCubit, CourseState>(
        // ignore: missing_return
        builder: (context, state) {
          //
          final courseCubit = context.watch<CourseCubit>();
          courseCubit.getCoursesByEnrollmentStatus(
              globals.authorizedTutee.id, widget.currentStatus);
          //
          if (state is CourseLoadingState) {
            return buildLoadingIndicator();
          } else if (state is CourseListLoadedState) {
            return Expanded(
              child: ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      //navigate to course detail screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CourseDetailScreen(
                                  courseId: state.courses[index].id,
                                  hasFollowButton: false,
                                )),
                      );
                    },
                    child: CourseCard(state.courses[index]),
                    // child: TutorCourseCard(context, state.courses[index]),
                  );
                },
              ),
            );
          } else if (state is CourseLoadFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
        },
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Container CourseCard(ExtendedCourse course) {
  //
  double courseCardHeight = 140;
  //
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(
      bottom: 20,
    ),
    child: Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        //
        Container(
          height: courseCardHeight,
          width: 335,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: mapStatusToColor(course.enrollmentStatus),
              boxShadow: [
                boxShadowStyle,
              ]),
        ),
        //
        Container(
          height: courseCardHeight,
          width: 324,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: backgroundColor,
          ),
        ),
        //

        Container(
          height: courseCardHeight,
          width: 324,
          padding: EdgeInsets.only(
            left: 25,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //course name
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  course.name,
                  style: titleStyle,
                ),
              ),
              //weekdays
              Text(
                course.daysInWeek.replaceFirst('[', '').replaceFirst(']', ''),
                style: textStyle,
              ),
              //begin-end time
              Text(
                course.beginTime.substring(0, 5) +
                    ' - ' +
                    course.endTime.substring(0, 5),
                style: textStyle,
              ),
              //begin date and status
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //begin date
                    Text(
                      'begin ',
                      style: TextStyle(
                          fontSize: textFontSize,
                          color: textGreyColor.withOpacity(0.7)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        course.beginDate,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //status
        Positioned(
          top: 15,
          right: 20,
          child: Column(
            children: [
              //avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  //avatar background color
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: mapStatusToColor(course.enrollmentStatus).withOpacity(.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  //avatar image
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      course.tutorAvatarUrl,
                    ),
                  ),
                  //
                ],
              ),
              //tutor name
              Container(
                padding: EdgeInsets.only(
                  top: 5,
                ),
                child: Text(
                  course.tutorName,
                  style: titleStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
