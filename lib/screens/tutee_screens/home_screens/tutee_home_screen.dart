import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/extended_models/course_tutor.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/feedback_repository.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/feedback_dialogs/feedback_dialog.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_map/api_key.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_map/tutee_search_map.dart';
import 'package:tutor_search_system/states/course_state.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;

//this var for check whether or not take feedback
bool isTakeFeedback = false;
int tutorId;

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
      // lazy: false,
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
                IconButton(
                  icon: const Icon(Icons.location_pin),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TuteeSearchGoogleMap(),
                      ),
                    );
                  },
                ),
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

// _createPolylines(Position start, Position destination) async {
//   polylinePoints = PolylinePoints();
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     GKey.API_KEY, // Google Maps API Key
//     PointLatLng(start.latitude, start.longitude),
//     PointLatLng(destination.latitude, destination.longitude),
//     travelMode: TravelMode.transit,
//   );

//   if (result.points.isNotEmpty) {
//     result.points.forEach((PointLatLng point) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });
//   }

//   PolylineId id = PolylineId('poly');
//   Polyline polyline = Polyline(
//     polylineId: id,
//     color: Colors.red,
//     points: polylineCoordinates,
//     width: 3,
//   );
//   polylines[id] = polyline;
// }

// double _coordinateDistance(lat1, lon1, lat2, lon2) {
//   var p = 0.017453292519943295;
//   var c = cos;
//   var a = 0.5 -
//       c((lat2 - lat1) * p) / 2 +
//       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//   return 12742 * asin(sqrt(a));
// }

// Future<bool> _calculateDistance(String start, String des) async {
//   try {
//     List<Location> startPlacemark = await locationFromAddress(start);
//     List<Location> destinationPlacemark = await locationFromAddress(des);

//     if (startPlacemark != null && destinationPlacemark != null) {
//       // Use the retrieved coordinates of the current position,
//       // instead of the address if the start position is user's
//       // current position, as it results in better accuracy.
//       Position startCoordinates = start == _currentAddress
//           ? Position(
//               latitude: _currentPosition.latitude,
//               longitude: _currentPosition.longitude)
//           : Position(
//               latitude: startPlacemark[0].latitude,
//               longitude: startPlacemark[0].longitude);
//       Position destinationCoordinates = Position(
//           latitude: destinationPlacemark[0].latitude,
//           longitude: destinationPlacemark[0].longitude);

//       await _createPolylines(startCoordinates, destinationCoordinates);
//       double totalDistance = 0.0;
//       // Calculating the total distance by adding the distance
//       // between small segments
//       for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//         totalDistance += _coordinateDistance(
//           polylineCoordinates[i].latitude,
//           polylineCoordinates[i].longitude,
//           polylineCoordinates[i + 1].latitude,
//           polylineCoordinates[i + 1].longitude,
//         );
//       }
//       _distance = totalDistance.toStringAsFixed(2);

//       return true;
//     }
//   } catch (e) {
//     print(e);
//   }
//   return false;
// }

//course inn gridview UI style
Container buildCourseGridView(CourseListLoadedState state) {
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
  GoogleMapController mapController;
  TutorRepository tutorRepository;
  Position _currentPosition;
  String _currentAddress;
  String _distance = '';
  Set<Marker> markers = {};
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String _startAddress = authorizedTutee.address;
  String _destinationAddress = '';

  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GKey.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<bool> _calculateDistance(String start, String des) async {
    try {
      List<Location> startPlacemark = await locationFromAddress(start);
      List<Location> destinationPlacemark = await locationFromAddress(des);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = start == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : Position(
                latitude: startPlacemark[0].latitude,
                longitude: startPlacemark[0].longitude);
        Position destinationCoordinates = Position(
            latitude: destinationPlacemark[0].latitude,
            longitude: destinationPlacemark[0].longitude);

        await _createPolylines(startCoordinates, destinationCoordinates);
        double totalDistance = 0.0;
        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }
        _distance = totalDistance.toStringAsFixed(1);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void initState() {
    super.initState();
    _destinationAddress = widget.course.address;
    _calculateDistance(_startAddress, _destinationAddress);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //navigate to course detail screen
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                    courseId: widget.course.id,
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
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              widget.course.studyForm,
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
                              _distance + ' km',
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                              widget.course.studyFee.toString(),
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

// Course Card
class VerticalCourseCard extends StatelessWidget {
  final CourseTutor course;
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
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  course.avatarImageLink != null
                                      ? course.avatarImageLink
                                      : ''),
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
                  course.fullname,
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
