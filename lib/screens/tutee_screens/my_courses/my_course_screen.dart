import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/states/course_state.dart';

String sortValue = 'Default sort';

class MyCourseScreen extends StatefulWidget {
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }
  //default seelcted status
  String _selectedStatus = 'All';
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1.5,
        // titleTextStyle: TextStyle(color: mainColor),
        title: Text(
          'My Courses',
          style:
              // GoogleFonts.kaushanScript(
              TextStyle(
            color: mainColor,
            fontSize: headerFontSize + 2,
            fontWeight: FontWeight.bold,
          ),
          // ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              alignment: Alignment.center,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  buildCourseStatusCard(0, 'All'),
                  buildCourseStatusCard(
                      1, globals.EnrollmentConstants.ACTIVE_STATUS),
                  buildCourseStatusCard(
                      2, globals.EnrollmentConstants.ONGOING_STATUS),
                  buildCourseStatusCard(
                      3, globals.EnrollmentConstants.INACTIVE_STATUS),
                ],
              ),
            ),
            CourseListView(
              currentStatus: _selectedStatus,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSSortButton(context),
    );
  }

  Widget _buildSSortButton(BuildContext context) {
    return SpeedDial(
      /// both Default sort to 16
      marginEnd: 18,
      marginBottom: 20,
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      /// This is ignored if animatedIcon is non null
      icon: Icons.sort_rounded,
      activeIcon: Icons.remove,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Default sorts to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, Default sorts to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size Default sorts to 56 itself, its the FAB size + It also affects relative padding and other elements
      buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
      closeManually: false,

      /// If true overlay will render no matter what.
      renderOverlay: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black.withOpacity(.1),
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(Icons.nature),
          backgroundColor: Colors.orange,
          label: 'Default sort',
          labelBackgroundColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            setState(() {
              sortValue = 'Default sort';
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.arrow_downward_sharp),
          backgroundColor: Colors.cyan,
          label: 'Newest',
          labelBackgroundColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            //
            setState(() {
              sortValue = 'Newest';
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.arrow_upward_sharp),
          label: 'Oldest',
          labelBackgroundColor: Colors.white,
          backgroundColor: Colors.cyan,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            //
            setState(() {
              sortValue = 'Oldest';
            });
          },
        ),
      ],
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
        width: 90,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              status,
              style: TextStyle(
                color: _selectedStatus == status ? mainColor : textGreyColor,
                fontSize: titleFontSize,
              ),
            ),
            Visibility(
              visible: _selectedStatus == status,
              child: Divider(
                color: mainColor,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
            )
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
          } else if (state is ExtendedCourseListLoadedState) {
            //
            if (sortValue == 'Oldest') {
              //asc
              state.courses
                  .sort((a, b) => a.followDate.compareTo(b.followDate));
            } else if (sortValue == 'Newest') {
              state.courses
                  .sort((a, b) => b.followDate.compareTo(a.followDate));
            }
            //
            return Expanded(
              child: Column(
                children: [
                  //
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.courses.length.toString() +
                          ' result(s)',
                          style: TextStyle(
                            fontSize: titleFontSize,
                          ),
                        ),
                        //
                        Text(
                          sortValue,
                          style: TextStyle(
                            fontSize: titleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
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
                                ),
                              ),
                            );
                          },
                          child: CourseCard(state.courses[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CourseLoadFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is CourseNoDataState) {
            return NoDataScreen();
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
                      color: mapStatusToColor(course.enrollmentStatus)
                          .withOpacity(.4),
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
