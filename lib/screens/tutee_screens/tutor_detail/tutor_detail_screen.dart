import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/enrollment_cubit.dart';
import 'package:tutor_search_system/cubits/tutor_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/extended_models/extended_tutor.dart';
import 'package:tutor_search_system/models/tutor.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/home_course_detail.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_map/tutee_search_map.dart';
import 'package:tutor_search_system/states/enrollment_state.dart';
import 'package:tutor_search_system/states/tutor_state.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorDetails extends StatelessWidget {
  final int tutorId;
  final Course course;
  final bool hasFollowButton;
  const TutorDetails(
      {Key key,
      @required this.tutorId,
      @required this.course,
      @required this.hasFollowButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorCubit(TutorRepository()),
      child:
          // ignore: missing_return
          BlocBuilder<TutorCubit, TutorState>(builder: (context, state) {
        //call category cubit and get all course
        final tutorCubit = context.watch<TutorCubit>();
        tutorCubit.getTutorByTutorId(tutorId);
        //render proper UI for each Course state
        if (state is TutorLoadingState) {
          return buildLoadingIndicator();
        } else if (state is ExtendedTutorLoadedState) {
          //
          print('this is certi' + state.tutor.certificationUrls.toString());
          //
          return Scaffold(
            appBar: AppBar(
              leading: buildDefaultBackButton(context),
            ),
            body: Container(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 60, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(
                                state.tutor.avatarImageLink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(140, 60, 0, 0),
                      child: Column(
                        children: [
                          Container(
                            child: Container(
                              width: 200,
                              height: 40,
                              child: Text(
                                state.tutor.fullname,
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
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
                              width: 210,
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "12",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Courses",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "125",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Reviews",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "176",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //tutor information
                    TutorInformation(
                      tutor: state.tutor,
                      course: course,
                    ),
                  ],
                ),
              ),
            ),
            //follow button
            floatingActionButton: Visibility(
                visible: hasFollowButton,
                child: buildFollowButton(context, course)),
          );
        } else if (state is TutorLoadFailedState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
      }),
    );
  }
}

class TutorInformation extends StatelessWidget {
  final ExtendedTutor tutor;
  final Course course;
  const TutorInformation({
    Key key,
    @required this.tutor,
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
          enrollmentCubit.getEnrollmentByCourseIdTuteeId(
              course.id, authorizedTutee.id);
          //
          bool isCensoredInfo = true;
          if (state is EnrollmentLoadedState) {
            if (state.enrollment != null &&
                state.enrollment.status ==
                    EnrollmentConstants.ACCEPTED_STATUS) {
              isCensoredInfo = false;
            }
          }
          //
          return ListView(
            children: [
              //
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 230, 0, 0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              tutor.description,
                              style: TextStyle(
                                color: textGreyColor,
                                fontSize: 11,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                          'assets/images/gender.png'),
                                    ),
                                    Text(tutor.gender)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                          'assets/images/birthday-cake.png'),
                                    ),
                                    Text(tutor.birthday)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                          'assets/images/email.png'),
                                    ),
                                    Stack(
                                      children: [
                                        //email
                                        GestureDetector(
                                          onTap: () {
                                            //ui to launch to email
                                            final Uri _emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path: tutor.email,
                                                queryParameters: {
                                                  'subject': authorizedTutee
                                                          .fullname +
                                                      ' ask to join you course!',
                                                  'body':
                                                      'I would like to contact you for your course! ...'
                                                });
                                            //launch
                                            launch(_emailLaunchUri
                                                .toString()
                                                .replaceAll('+', ' '));
                                          },
                                          child: Text(
                                            tutor.email,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: textFontSize,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                        //
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
                                                  color: Colors.black
                                                      .withOpacity(0),
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                          'assets/images/phone.png'),
                                    ),
                                    Stack(
                                      children: [
                                        //phone number
                                        GestureDetector(
                                          child: Text(
                                            tutor.phone,
                                            style: TextStyle(
                                              color: Colors.green,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          onTap: () {
                                            launch('tel:${tutor.phone}');
                                          },
                                        ),
                                        //
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
                                                  color: Colors.black
                                                      .withOpacity(0),
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

                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                          'assets/images/phone.png'),
                                    ),
                                    Stack(
                                      children: [
                                        //phone number
                                        GestureDetector(
                                          child: Text(
                                            tutor.address,
                                            style: TextStyle(
                                              color: Colors.red,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TuteeSearchGoogleMap(
                                                          tutoraddress:
                                                              tutor.address,
                                                          tuteeaddress:
                                                              authorizedTutee
                                                                  .address,
                                                        )));
                                          },
                                        ),
                                        //
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
                                                  color: Colors.black
                                                      .withOpacity(0),
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                          'assets/images/major.png'),
                                    ),
                                    Text(tutor.educationLevel)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //certification images
              Container(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        'Certification Image(s)',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: titleFontSize,
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        runAlignment: WrapAlignment.spaceBetween,
                        runSpacing: 10,
                        spacing: 10,
                        children: List.generate(tutor.certificationUrls.length,
                            (index) {
                          //view photo in fullscreen
                          return InkWell(
                            onTap: () {
                              //
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                    imageWidget: Image.network(
                                      tutor.certificationUrls[index],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 125,
                              width: 125,
                              child: Image.network(
                                tutor.certificationUrls[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
