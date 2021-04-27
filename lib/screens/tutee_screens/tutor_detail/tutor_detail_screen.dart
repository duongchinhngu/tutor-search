import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/enrollment_cubit.dart';
import 'package:tutor_search_system/cubits/feedback_cubit.dart';
import 'package:tutor_search_system/cubits/tutor_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/extended_models/extended_tutor.dart';
import 'package:tutor_search_system/models/feedback.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/feedback_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/home_course_detail.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_map/tutee_search_map.dart';
import 'package:tutor_search_system/states/enrollment_state.dart';
import 'package:tutor_search_system/states/feedback_state.dart';
import 'package:tutor_search_system/states/tutor_state.dart';
import 'package:url_launcher/url_launcher.dart';

FeedbackRepository feedbackRepository;

class TutorDetails extends StatefulWidget {
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
  _TutorDetailsState createState() => _TutorDetailsState();
}

class _TutorDetailsState extends State<TutorDetails> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorCubit(TutorRepository()),
      child:
          // ignore: missing_return
          BlocBuilder<TutorCubit, TutorState>(builder: (context, state) {
        //call category cubit and get all course
        final tutorCubit = context.watch<TutorCubit>();
        tutorCubit.getTutorByTutorId(widget.tutorId);
        //render proper UI for each Course state
        if (state is TutorLoadingState) {
          return buildLoadingIndicator();
        } else if (state is ExtendedTutorLoadedState) {
          //
          print('this is certi' + state.tutor.certificationUrls.toString());
          //
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Container(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Container(),
                    ),
                    Positioned(
                        top: 20,
                        left: 20,
                        child: buildDefaultCustomBackButton(
                            context, Colors.white)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 80, 0, 0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                            imageWidget: Image.network(
                                          state.tutor.avatarImageLink,
                                          fit: BoxFit.fitWidth,
                                        ))),
                              );
                            },
                            child: Container(
                              child: CircleAvatar(
                                radius: 65,
                                backgroundImage: NetworkImage(
                                  state.tutor.avatarImageLink,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(140, 85, 0, 0),
                      child: Column(
                        children: [
                          Container(
                            child: Container(
                              width: 200,
                              height: 30,
                              child: Text(
                                state.tutor.fullname,
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          // //star rate
                          Row(
                            children: [
                              //
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                  left: 10,
                                  bottom: 5,
                                ),
                                child: RatingBar.builder(
                                  itemSize: 25,
                                  ignoreGestures: true,
                                  initialRating: state.tutor.averageRatingStar,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // selectedRating = rating;
                                  },
                                ),
                              ),
                              //
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  '(' +
                                      state.tutor.numberOfFeedback.toString() +
                                      ' rates)',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
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
                            height: 60,
                            child: Container(
                              // padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    state.tutor.numberOfCourse.toString() +
                                        "\nCourses",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    state.tutor.numberOfTutee.toString() +
                                        "\nTutees",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    state.tutor.numberOfFeedback.toString() +
                                        "\nFeedbacks",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //tutor information
                    TutorInformation(
                      tutor: state.tutor,
                      course: widget.course,
                    ),
                  ],
                ),
              ),
            ),
            //follow button
            floatingActionButton: Visibility(
                visible: widget.hasFollowButton,
                child: buildFollowButton(context, widget.course)),
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
                state.enrollment.status == EnrollmentConstants.ACTIVE_STATUS) {
              isCensoredInfo = false;
            }
          }
          //
          return Padding(
            padding: const EdgeInsets.only(top: 210),
            child: Container(
              decoration: BoxDecoration(),
              child: ListView(
                children: [
                  //
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildCourseInformationListTile(
                                      tutor.gender, 'Gender', Icons.gesture),
                                  buildDivider(),
                                  buildCourseInformationListTile(
                                      tutor.birthday, 'Birthday', Icons.cake),

                                  buildDivider(),
                                  buildCourseInformationListTile(
                                      tutor.educationLevel,
                                      'Education Level',
                                      Icons.cast_for_education_outlined),
                                  buildDivider(),
                                  ListTile(
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
                                          Icons.email,
                                          color: mainColor,
                                        ),
                                      ),
                                      title: Text(
                                        'Mail Address',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500]),
                                      ),
                                      subtitle: Stack(
                                        children: [
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
                                              style: 'Mail Address' ==
                                                      'Course Name'
                                                  ? titleStyle
                                                  : TextStyle(
                                                      fontSize: titleFontSize,
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                            ),
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
                                                    color: Colors.black
                                                        .withOpacity(0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  buildDivider(),
                                  ListTile(
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
                                          Icons.phone_android,
                                          color: mainColor,
                                        ),
                                      ),
                                      title: Text(
                                        'Phone number',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500]),
                                      ),
                                      subtitle: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              launch('tel:${tutor.phone}');
                                            },
                                            child: Text(
                                              tutor.phone,
                                              style: TextStyle(
                                                fontSize: titleFontSize,
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
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
                                                    color: Colors.black
                                                        .withOpacity(0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  //
                                  buildDivider(),
                                  ListTile(
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
                                          Icons.home_outlined,
                                          color: mainColor,
                                        ),
                                      ),
                                      title: Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500]),
                                      ),
                                      subtitle: Stack(
                                        children: [
                                          GestureDetector(
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
                                            child: Text(
                                              tutor.address,
                                              style: TextStyle(
                                                fontSize: titleFontSize,
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
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
                                                    color: Colors.black
                                                        .withOpacity(0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  buildDivider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                        tutor.certificationUrls.length == 0
                                            ? Container(
                                                width: 260,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    'No certification image'),
                                              )
                                            : Container(
                                                width: 260,
                                                alignment: Alignment.centerLeft,
                                                child: Wrap(
                                                  runAlignment: WrapAlignment
                                                      .spaceBetween,
                                                  runSpacing: 10,
                                                  spacing: 10,
                                                  children: List.generate(
                                                      tutor.certificationUrls
                                                          .length, (index) {
                                                    //view photo in fullscreen
                                                    return InkWell(
                                                      onTap: () {
                                                        //
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullScreenImage(
                                                              imageWidget:
                                                                  Image.network(
                                                                tutor.certificationUrls[
                                                                    index],
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 125,
                                                        width: 125,
                                                        child: Image.network(
                                                          tutor.certificationUrls[
                                                              index],
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 10, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 40,
                                          ),
                                          child: Text(
                                            'Feedback from Tutee(s)',
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: titleFontSize,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            child: GetFeedback(
                                          tutorid: tutor.id,
                                        )),
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

class GetFeedback extends StatelessWidget {
  final int tutorid;

  const GetFeedback({Key key, this.tutorid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FeedbackCubit(FeedbackRepository()),
        child: BlocBuilder<FeedbackCubit, FeedbackState>(
            builder: (context, state) {
          final cubit = context.watch<FeedbackCubit>();
          // cubit.getFeedbackByTuteeId(authorizedTutor.id);
          cubit.getFeedbackByTutorId(tutorid);
          //
          if (state is FeedbackErrorState) {
            // return ErrorScreen();
            return Text(state.errorMessage);
          } else if (state is InitialFeedbackState) {
            return buildLoadingIndicator();
          } else if (state is FeedbackNoDataState) {
            return Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 40),
              child: Text('No feedback'),
            );
          } else if (state is FeedbackListLoadedState) {
            // return ListView.builder(
            //     itemCount: state.feedbacks.length,
            //     itemBuilder: (context, index) => CardFeedback(
            //           feedbacks: state.feedbacks[index],
            //         ));
            return _buildListFeedback(state);
          }
        }));
  }
}

Widget _buildListFeedback(FeedbackListLoadedState state) {
  return Container(
      child: Column(
    children: List.generate(
      state.feedbacks.length,
      (index) => ListFeedback(
        feedbacks: state.feedbacks[index],
      ),
    ),
  ));

  // return Container(
  //   child: GridView.builder(
  //     gridDelegate: SilverGridDelegte,

  //     itemCount: state.feedbacks.length,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) => ListFeedback(
  //       feedbacks: state.feedbacks[index],
  //     ),
  //   ),
  // );
}

class ListFeedback extends StatefulWidget {
  final Feedbacks feedbacks;

  const ListFeedback({Key key, this.feedbacks}) : super(key: key);
  @override
  _ListFeedbackState createState() => _ListFeedbackState();
}

class _ListFeedbackState extends State<ListFeedback> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          //
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //avatar
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.feedbacks.tuteeAvatarUrl),
                  radius: 30,
                ),
              ),
              //
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //name tutee
                      Text(
                        widget.feedbacks.tuteeName,
                        style: headerStyle,
                      ),
                      ////rate star
                      Container(
                        child: RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: widget.feedbacks.rate,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemSize: 20,
                          onRatingUpdate: (double value) {},
                        ),
                      ),
                      //content
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(widget.feedbacks.comment),
                      )
                    ],
                  ),
                ),
              ),
              //createdDate
              Expanded(
                flex: 2,
                child: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      widget.feedbacks.createdDate.substring(0, 10),
                      style: textStyle,
                    )),
              )
            ],
          ),
          //
          Divider(
            indent: 20,
            endIndent: 30,
          )
        ],
      ),
    );
  }
}

class CardFeedback extends StatelessWidget {
  final Feedbacks feedbacks;

  const CardFeedback({Key key, this.feedbacks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        //
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //avatar
            Expanded(
              flex: 2,
              child: CircleAvatar(
                backgroundImage: NetworkImage(feedbacks.tuteeAvatarUrl),
                radius: 30,
              ),
            ),
            //
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name tutee
                    Text(
                      feedbacks.tuteeName,
                      style: headerStyle,
                    ),
                    ////rate star
                    Container(
                      child: RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: feedbacks.rate,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 20,
                        onRatingUpdate: (double value) {},
                      ),
                    ),
                    //content
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(feedbacks.comment),
                    )
                  ],
                ),
              ),
            ),
            //createdDate
            Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    feedbacks.createdDate.substring(0, 10),
                    style: textStyle,
                  )),
            )
          ],
        ),
        //
        Divider(
          indent: 20,
          endIndent: 30,
        )
      ],
    );
  }
}
