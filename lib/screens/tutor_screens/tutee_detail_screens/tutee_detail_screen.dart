import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/cubits/enrollment_cubit.dart';
import 'package:tutor_search_system/cubits/tutee_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_map/tutee_search_map.dart';
import 'package:tutor_search_system/states/enrollment_state.dart';
import 'package:tutor_search_system/states/tutee_state.dart';
import 'package:url_launcher/url_launcher.dart';

class TuteeDetailScreen extends StatefulWidget {
  final int tuteeId;
  final Course course;

  const TuteeDetailScreen(
      {Key key, @required this.tuteeId, @required this.course})
      : super(key: key);
  @override
  _TuteeDetailScreenState createState() => _TuteeDetailScreenState();
}

class _TuteeDetailScreenState extends State<TuteeDetailScreen> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TuteeCubit(TuteeRepository()),
      child:
          // ignore: missing_return
          BlocBuilder<TuteeCubit, TuteeState>(builder: (context, state) {
        //call category cubit and get all course
        final tuteeCubit = context.watch<TuteeCubit>();
        tuteeCubit.getTuteeByTuteeId(widget.tuteeId);
        //render proper UI for each Course state
        if (state is TuteeLoadingState) {
          return buildLoadingIndicator();
        } else if (state is TuteeLoadedState) {
          //
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: mainColor,
              // title: Text('Tutee Profile'),
              centerTitle: true,
              leading: buildDefaultCustomBackButton(context, Colors.white),
            ),
            body: Container(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                            imageWidget: Image.network(
                                          state.tutee.avatarImageLink,
                                          fit: BoxFit.fitWidth,
                                        ))),
                              );
                            },
                            child: Container(
                              child: CircleAvatar(
                                radius: 65,
                                backgroundImage: NetworkImage(
                                  state.tutee.avatarImageLink,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 80),
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: 70,
                      child: Text(
                        state.tutee.fullname,
                        style: TextStyle(
                            color: textWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    //tutee information
                    TuteeInformation(
                      tutee: state.tutee,
                      course: widget.course,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is TuteeErrorState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
      }),
    );
  }
}

class TuteeInformation extends StatelessWidget {
  final Tutee tutee;
  final Course course;
  const TuteeInformation({
    Key key,
    @required this.tutee,
    @required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EnrollmentCubit(EnrollmentRepository()),
      child: BlocBuilder<EnrollmentCubit, EnrollmentState>(
        builder: (context, state) {
          //
          final enrollmentCubit = context.watch<EnrollmentCubit>();
          enrollmentCubit.getEnrollmentByCourseIdTuteeId(course.id, tutee.id);
          //
          bool isCensoredInfo = true;
          if (state is EnrollmentLoadedState) {
            if (state.enrollment != null &&
                state.enrollment.status == EnrollmentConstants.ACTIVE_STATUS) {
              isCensoredInfo = false;
            }
          }
          //
          return Container(
            padding: const EdgeInsets.only(top: 25),
            child: ListView(
              children: [
                //
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildCourseInformationListTile(
                                    tutee.gender, 'Gender', Icons.gesture),
                                buildDivider(),
                                buildCourseInformationListTile(
                                    tutee.birthday, 'Birthday', Icons.cake),
                                buildDivider(),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //ui to launch to email
                                        final Uri _emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: tutee.email,
                                            queryParameters: {
                                              'subject': authorizedTutor
                                                      .fullname +
                                                  ' ask to join you course!',
                                              'body':
                                                  'I am the tutor that you have followed recently via Easy Edu! ...'
                                            });
                                        //launch
                                        launch(_emailLaunchUri
                                            .toString()
                                            .replaceAll('+', ' '));
                                      },
                                      child: buildCourseInformationUrl(
                                          tutee.email, 'Email', Icons.mail),
                                    ),
                                    Visibility(
                                      visible: isCensoredInfo,
                                      child: Positioned.fill(
                                        child: ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaY: 5,
                                              sigmaX: 5,
                                            ),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                buildDivider(),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TuteeSearchGoogleMap(
                                                      tutoraddress:
                                                          authorizedTutor
                                                              .address,
                                                      tuteeaddress:
                                                          tutee.address,
                                                    )));
                                      },
                                      child: buildCourseInformationUrl(
                                          tutee.address, 'Address', Icons.map),
                                    ),
                                    Visibility(
                                      visible: isCensoredInfo,
                                      child: Positioned.fill(
                                        child: ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaY: 5,
                                              sigmaX: 5,
                                            ),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                buildDivider(),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        launch('tel:${tutee.phone}');
                                      },
                                      child: buildCourseInformationUrl(
                                          tutee.phone,
                                          'Phone number',
                                          Icons.phone_android),
                                    ),
                                    Visibility(
                                      visible: isCensoredInfo,
                                      child: Positioned.fill(
                                        child: ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaY: 5,
                                              sigmaX: 5,
                                            ),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
