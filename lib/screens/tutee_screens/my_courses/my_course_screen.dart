import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
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
Container CourseCard(Course course) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(
      bottom: 20,
    ),
    child: Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          height: 85,
          width: 335,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: mapStatusToColor(course.status),
              boxShadow: [
                boxShadowStyle,
              ]),
        ),
        Container(
          height: 85,
          width: 324,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: backgroundColor,
          ),
        ),
        Container(
          height: 85,
          width: 324,
          padding: EdgeInsets.only(
            left: 15,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  course.name,
                  style: titleStyle,
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'state.tutor.avatarImageLink',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsetsDirectional.only(
                            start: 10,
                          ),
                          child: Text(
                            'Tutor ' + course.createdBy.toString(),
                            style: textStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: course.status == 'Accepted'
                                      ? mainColor
                                      : (course.status == 'Denied')
                                          ? Colors.red
                                          : Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                child: Text(
                                  course.status,
                                  style: textStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
