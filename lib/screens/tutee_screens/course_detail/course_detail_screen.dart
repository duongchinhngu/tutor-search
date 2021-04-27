import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/models/feedback.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/feedback_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_map/tutee_search_map.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_course_detail_screens/tutor_course_detail_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutor_detail/tutor_detail_screen.dart';
import 'package:tutor_search_system/states/course_state.dart';

bool canFeedback = false;
bool isSending = false;

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({Key key, @required this.courseId})
      : super(key: key);
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Position _currentPosition;
  String _currentAddress = '';

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
      await _getAddress();
      // await _genCurrentAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      print('latitude: ' + _currentPosition.latitude.toString());
      print('longitude: ' + _currentPosition.longitude.toString());

      Placemark place = p[0];
      print('1 ${place.name}');
      print('2 ${place.administrativeArea}');
      print('3 ${place.country}');
      print('4 ${place.isoCountryCode}');
      print('5 ${place.locality}');
      print('6 ${place.postalCode}');
      print('7 ${place.street}');
      print('8 ${place.subAdministrativeArea}');
      print('9 ${place.subLocality}');
      print('10 ${place.subThoroughfare}');
      print('11 ${place.thoroughfare}');

      setState(() {
        _currentAddress =
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        print('ALO ALO ALO ALO: ' + _currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit(CourseRepository()),
      child: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          //
          final courseCubit = context.watch<CourseCubit>();
          courseCubit.getCoursesByCourseIdTuteeId(
              widget.courseId, authorizedTutee.id);
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
              backgroundColor: backgroundColor,
              appBar: buildCourseDetailAppbar(context),
              body: buildCourseDetailBody(context, state.course),
              floatingActionButton: Visibility(
                child: buildFeedbackButton(context, state.course),
                visible: state.course.enrollmentStatus == 'Inactive' &&
                    state.course.isFeedback == false,
              ),
            );
          }
        },
      ),
    );
  }

  //course detail body
  Container buildCourseDetailBody(BuildContext context, ExtendedCourse course) {
    List<String> extraImages = [];
    //
    if (course.extraImages != '[]') {
      extraImages = course.extraImages
          .replaceFirst(']', '')
          .replaceFirst('[', '')
          .split(', ');
    }
    //
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          //course name title
          Container(
            alignment: Alignment.center,
            height: 60,
            padding: EdgeInsets.only(
              top: 30,
            ),
            child: Text(
              course.name,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: textGreyColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          //status
          Container(
            margin: EdgeInsets.only(
              left: 110,
              right: 110,
              bottom: 20,
              top: 10,
            ),
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mapStatusToColor(course.enrollmentStatus),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              course.enrollmentStatus,
              style: TextStyle(
                fontSize: titleFontSize,
                color: textWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //
          //
          buildDivider(),
          //tutor sumary and initro
          Container(
            height: 120,
            width: 324,
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TutorDetails(
                      tutorId: course.createdBy,
                      course: course,
                      hasFollowButton: false,
                    ),
                  ),
                );
              },
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
                          color: Colors.tealAccent.withOpacity(.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      //avatar image
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          course.tutorAvatarUrl,
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
                          course.tutorName,
                          style: titleStyle,
                        ),
                        //five star here
                      ],
                    ),
                  ),
                  //arrow
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: textGreyColor,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          buildDivider(),
          //course name
          buildCourseInformationListTile(
              course.subjectName, 'Subject', Icons.subject),
          buildDivider(),
          //course name
          buildCourseInformationListTile(
              course.className, 'Class', Icons.grade),
          buildDivider(),
          //location
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TuteeSearchGoogleMap(
                        tutoraddress: course.location,
                        tuteeaddress: _currentAddress,
                      )));
            },
            child: buildCourseInformationUrl(
                course.location == course.tutorAddress
                    ? 'At Tutor Home'
                    : course.location,
                'Location',
                Icons.location_on_outlined),
          ),
          buildDivider(),
          //study time
          buildCourseInformationListTile(
              course.beginTime + ' - ' + course.endTime,
              'Study Time',
              Icons.access_time),
          buildDivider(),
          //study week days
          buildCourseInformationListTile(
            course.daysInWeek.replaceFirst('[', '').replaceFirst(']', ''),
            'Days In Week',
            Icons.calendar_today,
          ),
          buildDivider(),
          //begin and end date
          buildCourseInformationListTile(
            course.beginDate + ' to ' + course.endDate,
            'Begin - End Date',
            Icons.date_range,
          ),
          buildDivider(),
          //price of the course
          buildCourseInformationListTile(
            '\$' + course.studyFee.toString(),
            'Study Fee',
            Icons.monetization_on,
          ),
          buildDivider(),
          //description for this course
          buildCourseInformationListTile(
            course.description != '' ? course.description : 'No description',
            'Extra Information',
            Icons.description,
          ),
          buildDivider(),
          //created date of this course
          buildCourseInformationListTile(
            course?.followDate,
            'Follow Date',
            Icons.calendar_today,
          ),
          buildDivider(),
          //extra images
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 5, left: 5),
            child: Column(
              children: [
                //
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 40),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Extra Images',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: mainColor,
                    ),
                  ),
                ),
                //
                extraImages.length != 0
                    ? Wrap(
                        runAlignment: WrapAlignment.spaceBetween,
                        runSpacing: 5,
                        spacing: 5,
                        children: List.generate(extraImages.length, (index) {
                          //view photo in fullscreen
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                    imageWidget: Image.network(
                                      extraImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 114,
                              width: 114,
                              child: Image.network(
                                extraImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                      )
                    : Text('No extra images', style: textStyle),
              ],
            ),
          ),
          buildDivider(),
          //course status
          // Container(
          //   padding: EdgeInsets.only(
          //     left: 30,
          //     right: 30,
          //   ),
          //   child: ListTile(
          //     leading: Text(
          //       'Course status',
          //       style: titleStyle,
          //     ),
          //     trailing: Container(
          //       height: 35,
          //       width: 80,
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //         color: mapStatusToColor(course.status),
          //         borderRadius: BorderRadius.circular(24),
          //       ),
          //       child: Text(
          //         course.status,
          //         style: TextStyle(
          //           fontSize: textFontSize,
          //           color: textWhiteColor,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // Visibility(
          //   visible: canFeedback,
          //   child: buildFeedbackButton(context),
          // ),
          //this widget for being nice only
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

Future showFeedbackDialog(BuildContext context, ExtendedCourse course) {
  return showDialog(
    barrierDismissible: !isSending,
    context: context,
    builder: (context) => Dialog(
      backgroundColor: backgroundColor,
      elevation: 1.0,
      insetAnimationCurve: Curves.ease,
      child: FeedbackDialogBody(course: course),
    ),
  );
}

Container _buildFeedbackTitle() {
  return Container(
    alignment: Alignment.centerLeft,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //feedback icon
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            'assets/images/feedback.png',
            height: 50,
            width: 50,
            color: Colors.green,
          ),
        ),
        //label
        Text(
          'Feedback your tutor !',
          style: TextStyle(
            fontSize: headerFontSize,
            fontWeight: FontWeight.bold,
            color: defaultBlueTextColor,
          ),
        ),
      ],
    ),
  );
}

Future<dynamic> showFeedbackCompletedDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //complete icon
            Container(
              height: 100,
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.check_circle_outlined,
                size: 80,
                color: Colors.greenAccent[700],
              ),
            ),
            //thank you title
            Container(
              child: Text(
                'Thank You, ' + authorizedTutee.fullname + '!',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: textGreyColor,
                    fontSize: headerFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //explanation text field
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 30,
              ),
              child: Text(
                'Your feedback will improve the tutor and\nour services for your next experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textFontSize,
                  color: Colors.grey,
                ),
              ),
            ),
            //
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 94,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor,
                ),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: textWhiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class FeedbackDialogBody extends StatefulWidget {
  final ExtendedCourse course;

  const FeedbackDialogBody({Key key, this.course}) : super(key: key);

  @override
  _FeedbackDialogBodyState createState() => _FeedbackDialogBodyState();
}

class _FeedbackDialogBodyState extends State<FeedbackDialogBody> {
  //text controller for comment
  TextEditingController commentController = TextEditingController();
  //rating point
  double selectedRating = 3.0;

  //
  final feedbackRepository = FeedbackRepository();
  //
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IgnorePointer(
        ignoring: isSending,
        ignoringSemantics: true,
        child: Container(
          height: 460,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //title and icon label
              _buildFeedbackTitle(),
              //row user avatar; course name; tutor name
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //avatar
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        widget.course.tutorAvatarUrl,
                      ),
                    ),
                    //COlumn of tutor gender and tutor name
                    Container(
                      padding: EdgeInsetsDirectional.only(
                        start: 7,
                      ),
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //tutor name
                          Container(
                            width: 150,
                            child: Text(
                              widget.course.tutorName,
                              style: titleStyle,
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 150,
                            child: Text(
                              widget.course.name,
                              style: textStyle,
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //star rate
              Container(
                child: RatingBar.builder(
                  initialRating: selectedRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    selectedRating = rating;
                  },
                ),
              ),
              //comment
              Container(
                height: 180,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10, bottom: 0),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextFormField(
                  readOnly: isSending,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLength: 500,
                  maxLines: null,
                  controller: commentController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    fillColor: Color(0xffF9F2F2),
                    filled: true,
                    focusedBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 0.0),
                    ),
                    counter: Text(''),
                    hintText:
                        'How do you feel about this course,\ntutor, experiences..',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: textFontSize,
                    ),
                  ),
                ),
              ),
              // send button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    // to lock screen
                    setState(() {
                      isSending = !isSending;
                      //
                    });
                    //init feedback dto
                    //tutorId here is 1; temporary
                    final feedback = Feedbacks.constructor(
                      //id
                      0,
                      //comment
                      commentController.text,
                      //to tutorId
                      widget.course.createdBy,
                      // //create date
                      // defaultDatetime,
                      //status
                      'Pending',
                      //tutee id
                      authorizedTutee.id,
                      //rate
                      selectedRating,
                      //this is temporary value; back end will process this
                      // defaultDatetime,
                      //this is temporary value; back end will process this
                      // 0,
                    );
                    //post feedback
                    await feedbackRepository
                        .postFeedback(feedback)
                        .then((value) => {
                              //close feedback dialog
                              Navigator.of(context).pop(),
                              // show complete feeback
                              showFeedbackCompletedDialog(context),
                              //
                            })
                        .catchError((error) => {
                              //close feedback dialog
                              Navigator.of(context).pop(),
                              ScaffoldMessenger.of(context).showSnackBar(
                                buildDefaultSnackBar(
                                  Icons.error_outline,
                                  'Sending feedback failed..',
                                  'Please try again later.',
                                  Colors.red[900],
                                ),
                              ),
                            });
                    //
                    final enrollment = await EnrollmentRepository()
                        .fetchEnrollmentById(widget.course.enrollmentId);
                    //
                    await EnrollmentRepository()
                        .putEnrollment(enrollment)
                        .then((value) {
                      isSending = false;
                    });
                  },
                  child: Container(
                    width: 94,
                    height: 38,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: mainColor,
                    ),
                    child: Text(
                      isSending ? 'Sending..' : 'Send',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: textWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

FloatingActionButton buildFeedbackButton(
        BuildContext context, ExtendedCourse course) =>
    FloatingActionButton.extended(
      onPressed: () => {showFeedbackDialog(context, course)},
      label: Text(
        'Feedback',
        style: TextStyle(
          fontSize: titleFontSize,
          color: textWhiteColor,
        ),
      ),
      isExtended: true,
      backgroundColor: mainColor,
    );

FloatingActionButton buildPayNowButton(
        BuildContext context, ExtendedCourse course) =>
    FloatingActionButton.extended(
      onPressed: () {
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TuteePaymentScreen(course: course, enrollment: widg,),
        //   ),
        // );
      },
      label: Text(
        'Pay now',
        style: TextStyle(
          fontSize: titleFontSize,
          color: textWhiteColor,
        ),
      ),
      isExtended: true,
      backgroundColor: mainColor,
    );

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

ListTile buildCourseInformationUrl(
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
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
    ),
  );
}

ListTile buildCourseInformationListTileBlurInfo(
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
      subtitle: Stack(
        children: [
          Text(
            content,
            style: title == 'Course Name'
                ? titleStyle
                : TextStyle(
                    fontSize: titleFontSize,
                    color: textGreyColor,
                  ),
          ),
          Visibility(
            visible: true,
            child: Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
}

//default divider for this page
Divider buildDivider() {
  return Divider(
    thickness: 1,
    indent: 30,
    endIndent: 30,
  );
}
