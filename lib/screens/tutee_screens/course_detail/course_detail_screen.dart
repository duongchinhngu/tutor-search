import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/cubits/tutor_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_payment/tutee_payment_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutor_detail/tutor_detail_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/create_course_screens/create_course_variables.dart';
import 'package:tutor_search_system/states/course_state.dart';
import 'package:tutor_search_system/states/tutor_state.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final bool hasFollowButton;

  const CourseDetailScreen(
      {Key key, @required this.courseId, @required this.hasFollowButton})
      : super(key: key);
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit(CourseRepository()),
      child: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          //
          final courseCubit = context.watch<CourseCubit>();
          courseCubit.getCoursesByCourseId(widget.courseId);
          //
          //render proper ui
          if (state is CourseLoadingState) {
            return buildLoadingIndicator();
          } else if (state is CourseLoadFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is CourseLoadedState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: backgroundColor,
                elevation: 1.5,
                title: Text(
                  'Course Detail',
                  style: GoogleFonts.kaushanScript(
                    textStyle: TextStyle(
                      color: mainColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                centerTitle: true,
                leading: buildDefaultBackButton(context),
              ),
              body: Container(
                color: backgroundColor,
                child: ListView(
                  children: <Widget>[
                    //tutor intro card
                    TutorCard(
                      tutorId: state.course.createdBy,
                      courseId: state.course.id,
                    ),
                    //all COurse detail information
                    //course name
                    buildCourseInformationListTile(
                        state.course.name, 'Course Name', Icons.library_books),
                    buildDivider(),
                    //course name
                    buildCourseInformationListTile(
                        state.course.classHasSubjectId.toString(),
                        'Subject',
                        Icons.subject),
                    buildDivider(),
                    //course name
                    buildCourseInformationListTile(
                        state.course.name, 'Class', Icons.grade),
                    buildDivider(),
                    //school
                    buildCourseInformationListTile(
                        state.course.studyForm, 'Study Form', Icons.school),
                    buildDivider(),
                    //study time
                    buildCourseInformationListTile(
                        state.course.beginTime + ' - ' + state.course.endTime,
                        'Study Time',
                        Icons.access_time),
                    buildDivider(),
                    //study week days
                    buildCourseInformationListTile(
                      state.course.daysInWeek
                          .replaceFirst('[', '')
                          .replaceFirst(']', ''),
                      'Days In Week',
                      Icons.calendar_today,
                    ),
                    buildDivider(),
                    //begin and end date
                    buildCourseInformationListTile(
                      state.course.beginDate + ' to ' + state.course.endDate,
                      'Begin - End Date',
                      Icons.date_range,
                    ),
                    buildDivider(),
                    //price of the course
                    buildCourseInformationListTile(
                      '\$' + state.course.studyFee.toString(),
                      'Study Fee',
                      Icons.monetization_on,
                    ),
                    buildDivider(),
                    //price of the course
                    buildCourseInformationListTile(
                      state.course.maxTutee.toString(),
                      'Maximum tutee',
                      Icons.person,
                    ),
                    buildDivider(),
                    //description for this course
                    buildCourseInformationListTile(
                      state.course.description == ''
                          ? 'No description'
                          : state.course.description,
                      'Extra Information',
                      Icons.description,
                    ),
                    buildDivider(),
                    //created date of this course
                    Visibility(
                      visible: !widget.hasFollowButton,
                      child: buildCourseInformationListTile(
                        state.course.endDate,
                        'Follow Date',
                        Icons.calendar_today,
                      ),
                    ),
                    //this widget for being nice only
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
              floatingActionButton: Visibility(
                visible: widget.hasFollowButton,
                child: buildFollowButton(state.course),
              ),
            );
          }
        },
      ),
    );
  }

  FloatingActionButton buildFollowButton(Course course) =>
      FloatingActionButton.extended(
        onPressed: () {
          //navigate to Payment Screen
          //payment screeen wil process properly
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TuteePaymentScreen(course: course),
            ),
          );
        },
        label: Text(
          'Follow',
          style: TextStyle(
            fontSize: titleFontSize,
            color: textWhiteColor,
          ),
        ),
        isExtended: true,
        backgroundColor: mainColor,
      );
}

//tutor card on top of the screen
class TutorCard extends StatelessWidget {
  final int tutorId;
  final int courseId;

  const TutorCard({Key key, @required this.tutorId, @required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorCubit(TutorRepository()),
      child: BlocBuilder<TutorCubit, TutorState>(
        builder: (context, state) {
          //
          final tutorCubit = context.watch<TutorCubit>();
          tutorCubit.getTutorByTutorId(tutorId);
          //
          //render proper ui
          if (state is TutorLoadingState) {
            return buildLoadingIndicator();
          } else if (state is TutorLoadFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is TutorLoadedState) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TutorDetails(
                      tutorId: tutorId,
                      courseId: courseId,
                    ),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(10),
                elevation: 3,
                child: Container(
                  height: 140,
                  child: Row(
                    children: <Widget>[
                      //tutor avatar
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  state.tutor.avatarImageLink,
                                ),
                              ),
                            ),
                            Container(
                              child: Text('Five stars here'),
                            )
                          ],
                        ),
                      ),
                      //tutor name and description column
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                state.tutor.fullname,
                                style: titleStyle,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                state.tutor.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

//course infortion listtitle
ListTile buildCourseInformationListTile(
    String content, String title, IconData icon) {
  return ListTile(
    leading: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
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
    subtitle: Text(
      content,
      style: title == 'Course Name'
          ? titleStyle
          : TextStyle(
              fontSize: titleFontSize,
              color: textGreyColor,
            ),
    ),
  );
}

//default divider for this page
Divider buildDivider() {
  return Divider(
    thickness: 1,
    indent: 30,
    endIndent: 30,
  );
}
