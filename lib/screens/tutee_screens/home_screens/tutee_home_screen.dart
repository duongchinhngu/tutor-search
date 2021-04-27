import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/extended_models/course_tutor.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/feedback_repository.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/home_course_detail.dart';
import 'package:tutor_search_system/screens/tutee_screens/feedback_dialogs/feedback_dialog.dart';
import 'package:tutor_search_system/screens/tutee_screens/interested_subject_selector_dialog/interested_subject_selector_dialog.dart';
import 'package:tutor_search_system/states/course_state.dart';
import 'package:http/http.dart' as http;

//this var for check whether or not take feedback
bool isTakeFeedback = false;
//List of interested subject ids for fileter
List<String> _interestedSubjects = [];

class TuteeHomeScreen extends StatefulWidget {
  @override
  _TuteeHomeScreenState createState() => _TuteeHomeScreenState();
}

class _TuteeHomeScreenState extends State<TuteeHomeScreen> {
  //
  final loginRepository = LoginRepository();
  //
  final feedbackRepository = FeedbackRepository();

  Position _currentPosition;
  String _currentAddress = '';

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
      await _getAddress();
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
    //show dialog for choosing interested subject seletor
    // Future<SharedPreferences> prefs =
    SharedPreferences.getInstance().then((prefs) {
      List<String> ids = prefs.getStringList(
          'interestedSubjectsOf' + authorizedTutee.id.toString());
      //
      if (ids != null) {
        print('this is selecteabel: ' + ids.toString());
        _interestedSubjects = ids;
      } else {
        showModalBottomSheet(
            isScrollControlled: true,
            elevation: 10,
            backgroundColor: backgroundColor,
            context: context,
            builder: (context) => InterestedSubjectSelectorDialog());
      }
    });

    _getCurrentLocation();
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
        classCubit.getTuteeHomeCourses(_currentAddress);
        //render proper UI for each Course state
        if (state is CourseLoadingState) {
          return buildLoadingIndicator();
        } else if (state is CourseNoDataState) {
          return NoDataScreen();
        } else if (state is CourseTutorListLoadedState) {
          //apply sort course by interested subjects first in list
          // if (_interestedSubjects != null) {
          //   state.courses =
          //       sortByInterestedSubject(_interestedSubjects, state.courses);
          // }

          //load all course and then load courses by class id
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              title: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  List<String> ids = prefs.getStringList(
                      'interestedSubjectsOf' + authorizedTutee.id.toString());
                  for (var i in ids) {
                    print('this is id: ' + i);
                  }
                },
                child: Text(
                  "EasyEdu",
                  style: GoogleFonts.kaushanScript(
                    textStyle: TextStyle(
                      color: textWhiteColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
Container buildCourseGridView(CourseTutorListLoadedState state) {
  //
  // state.courses.sort((a, b) => a.distance.compareTo(b.distance));
  //
  return Container(
    child: GridView.builder(
      itemCount: state.courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 4,
      ),
      itemBuilder: (context, index) => CourseCard(
        course: state.courses[index],
      ),
    ),
  );
}

class CourseCard extends StatefulWidget {
  final CourseTutor course;

  const CourseCard({Key key, @required this.course}) : super(key: key);
  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //navigate to course detail screen
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => TuteeHomeCourseDetailScreen(
                    courseId: widget.course.id,
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
                                widget.course.name,
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
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  widget.course.avatarImageLink != null
                                      ? widget.course.avatarImageLink
                                      : ''),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // //star rate
              Container(
                child: RatingBar.builder(
                  itemSize: 25,
                  ignoreGestures: true,
                  initialRating: widget.course.averageRatingStar,
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
              Container(
                child: Text(
                  widget.course.fullname,
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
                            child: Text(
                              widget.course.availableSlot.toString()
                                  // + '/' + widget.course.maxTutee.toString()
                                  +
                                  ' slot(s) left',
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              widget.course.beginTime,
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              // _distance + ' km',
                              widget.course.distance.toString() + ' km',
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              '\$' + widget.course.studyFee.toString(),
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
