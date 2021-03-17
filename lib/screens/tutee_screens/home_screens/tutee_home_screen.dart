import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/feedback_repository.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/feedback_dialogs/feedback_dialog.dart';
import 'package:tutor_search_system/states/course_state.dart';
import 'package:http/http.dart' as http;

//this var for check whether or not take feedback
bool isTakeFeedback = false;

//
class TuteeHomeScreen extends StatefulWidget {
  @override
  _TuteeHomeScreenState createState() => _TuteeHomeScreenState();
}

class _TuteeHomeScreenState extends State<TuteeHomeScreen> {
  //
  final loginRepository = LoginRepository();
  //
  final feedbackRepository = FeedbackRepository();
  //
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);

    super.initState();
    //check feedback for this authorized tutee
    if (!isTakeFeedback) {
      feedbackRepository
          .fetchUnfeedbackTutorByTuteeId(http.Client(), authorizedTutee.id)
          .then(
            (value) => {
              if (value != null)
                {
                  showFeedbackDialog(context, value).then((value) => {
                        isTakeFeedback = true,
                        //set isSending is false when sended feedback to DB
                        isSending = false,
                        //
                      }),
                }
            },
          );
    }
    //
  }

  //
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit(CourseRepository()),
      child:
          // ignore: missing_return
          BlocBuilder<CourseCubit, CourseState>(builder: (context, state) {
        //call category cubit and get all course
        final classCubit = context.watch<CourseCubit>();
        classCubit.getTuteeHomeCourses();
        //render proper UI for each Course state
        if (state is CourseLoadingState) {
          return buildLoadingIndicator();
        } else if (state is CourseListLoadedState) {
          //load all course and then load courses by class id
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              title: Text(
                "EasyEdu",
                style: GoogleFonts.kaushanScript(
                  textStyle: TextStyle(
                    color: textWhiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    //sign out
                    showLogoutConfirmDialog(context);
                  },
                  child: Center(
                    child: Text('Sign out'),
                  ),
                ),
              ],
            ),
            body: buildCourseGridView(state),
          );
        } else if (state is CourseLoadFailedState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
      }),
    );
  }
}

//course inn gridview UI style
Container buildCourseGridView(CourseListLoadedState state) {
  return Container(
    child: GridView.builder(
      itemCount: state.courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 4,
      ),
      itemBuilder: (context, index) => VerticalCourseCard(
        course: state.courses[index],
      ),
    ),
  );
}

//Course Card
class VerticalCourseCard extends StatelessWidget {
  final Course course;

  const VerticalCourseCard({Key key, @required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //navigate to course detail screen
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                    courseId: course.id,
                    hasFollowButton: true,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 7, 8, 6.5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          width: 60,
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Container(
                    width: 200,
                    height: 150,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(13, 15, 13, 60),
                              child: Text(
                                course.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textWhiteColor,
                                  fontSize: titleFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Container(
                              width: 95,
                              height: 95,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: Colors.black,
                                  //   width: 1,
                                  // ),
                                  shape: BoxShape.circle,
                                  color: Colors.white),
                              child: FlutterLogo(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/starsmall.png'),
                  Image.asset('assets/images/starsmall.png'),
                  Image.asset('assets/images/starsmall.png'),
                  Image.asset('assets/images/starsmall.png'),
                  Image.asset('assets/images/starsmall.png'),
                ],
              ),
              Container(
                child: Text(
                  "Nguyen Trung Huy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textGreyColor,
                    fontSize: textFontSize,
                  ),
                  // style: titleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 15),
                            margin: const EdgeInsets.only(top: 5),
                            child: Image.asset('assets/images/studyicon.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Image.asset('assets/images/clockicon.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:
                                Image.asset('assets/images/distanceicon.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Image.asset('assets/images/pricetag.png'),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              course.studyForm,
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              course.beginTime,
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              '200m',
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              course.studyFee.toString(),
                              style: textStyle,
                            ),
                          ),
                        ],
                      )
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
