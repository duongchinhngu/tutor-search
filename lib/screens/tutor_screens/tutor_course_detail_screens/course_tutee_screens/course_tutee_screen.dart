import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/enrollment_cubit.dart';
import 'package:tutor_search_system/cubits/tutee_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/states/enrollment_state.dart';
import 'package:tutor_search_system/states/tutee_state.dart';

class CourseTuteeScreen extends StatefulWidget {
  final Course course;

  const CourseTuteeScreen({Key key, @required this.course}) : super(key: key);
  @override
  _CourseTuteeScreenState createState() => _CourseTuteeScreenState();
}

class _CourseTuteeScreenState extends State<CourseTuteeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
            elevation: 0.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/top-instructional-design-theories-models-next-elearning-course.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            )),
      ),
      body: BlocProvider(
        create: (context) => TuteeCubit(TuteeRepository()),
        child: BlocBuilder<TuteeCubit, TuteeState>(
          builder: (context, state) {
            //
            final tuteeCubit = context.watch<TuteeCubit>();
            tuteeCubit.getTuteesByCourseId(widget.course.id);
            //
            if (state is TuteeLoadingState) {
              return buildLoadingIndicator();
            } else if (state is TuteeErrorState) {
              return ErrorScreen();
            } else if (state is TuteeNoDataState) {
              return NoDataScreen();
            } else if (state is TuteeListLoadedState) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  itemCount: state.tutees.length,
                  itemBuilder: (context, index) {
                    return TuteeCard(
                      tutee: state.tutees[index],
                      course: widget.course,
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

//tutee card to show summary info
class TuteeCard extends StatelessWidget {
  final Tutee tutee;
  final Course course;

  const TuteeCard({Key key, @required this.tutee, @required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    double courseCardHeight = 140;
    //
    return BlocProvider(
      create: (context) => EnrollmentCubit(EnrollmentRepository()),
      lazy: false,
      child: BlocBuilder<EnrollmentCubit, EnrollmentState>(
        builder: (context, state) {
          //
          final enrollmentCubit = context.watch<EnrollmentCubit>();
          enrollmentCubit.getEnrollmentByCourseIdTuteeId(course.id, tutee.id);
          //
          return GestureDetector(
            onTap: () {
              //update enrollment status
              if (state is EnrollmentLoadedState) {
                showDialog(
                  context: context,
                  builder: (context) => buildDefaultDialog(
                    context,
                    'Accept this follower to be your tutee!',
                    'Do it now!',
                    [
                      ElevatedButton(
                        onPressed: () {
                          state.enrollment.status =
                              EnrollmentConstants.DENIED_STATUS;
                          //
                          Navigator.pop(context);
                          //
                          EnrollmentRepository()
                              .putEnrollment(state.enrollment)
                              .onError((error, stackTrace) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(buildDefaultSnackBar(
                              Icons.error_outline,
                              'Error!',
                              'Deny follower failed.',
                              Colors.red,
                            ));
                          });
                          //show done message after done update enrollment status
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildDefaultSnackBar(
                              Icons.check_circle_outline_outlined,
                              'Denied Successully!',
                              'Give other followers a chance.',
                              Colors.green,
                            ),
                          );
                        },
                        child: Text('Deny'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          state.enrollment.status =
                              EnrollmentConstants.ACCEPTED_STATUS;
                          //
                          Navigator.pop(context);
                          //
                          EnrollmentRepository()
                              .putEnrollment(state.enrollment)
                              .onError((error, stackTrace) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(buildDefaultSnackBar(
                              Icons.error_outline,
                              'Error!',
                              'Accept follower failed.',
                              Colors.red,
                            ));
                          });
                          //show done message after done update enrollment status
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildDefaultSnackBar(
                              Icons.check_circle_outline_outlined,
                              'Accepted Successfully!',
                              'Contact now!',
                              Colors.green,
                            ),
                          );
                        },
                        child: Text('Accept'),
                      )
                    ],
                  ),
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: 20,
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  //for Ui
                  Container(
                    height: courseCardHeight,
                    width: 335,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: state is EnrollmentLoadedState
                            ? mapStatusToColor(state.enrollment.status)
                            : Colors.white,
                        boxShadow: [
                          boxShadowStyle,
                        ]),
                  ),
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
                      left: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //tutee avatar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            //avatar background color
                            Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                color: state is EnrollmentLoadedState
                                    ? mapStatusToColor(state.enrollment.status)
                                        .withOpacity(.4)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            //avatar image
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                tutee.avatarImageLink,
                              ),
                            ),
                            //
                          ],
                        ),
                        //
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //tutee name
                              Text(
                                tutee.fullname,
                                style: titleStyle,
                              ),
                              //gender
                              Text(
                                tutee.gender,
                                style: textStyle,
                              ),
                              //years old
                              Text(
                                getYearOldFromBithdayString(tutee.birthday)
                                        .toString() +
                                    ' years old',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //enrollment status
                  Positioned(
                    top: 110,
                    right: 30,
                    child: Container(
                      // margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          //status
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: state is EnrollmentLoadedState
                                  ? mapStatusToColor(state.enrollment.status)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              // state.enrollment.status,
                              state is EnrollmentLoadedState
                                  ? state.enrollment.status
                                  : 'Loading..',
                              style: TextStyle(
                                fontSize: textFontSize,
                                color: state is EnrollmentLoadedState
                                    ? mapStatusToColor(state.enrollment.status)
                                    : textGreyColor,
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
        },
      ),
    );
  }
}
