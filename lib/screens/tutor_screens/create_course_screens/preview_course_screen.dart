import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/commission_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/repositories/commission_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/course_detail/course_detail_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/create_course_screens/create_course_processing_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_course_detail_screens/tutor_course_detail_screen.dart';
import 'package:tutor_search_system/states/commission_state.dart';
import 'create_course_variables.dart' as vars;

class PreviewCourseScreen extends StatefulWidget {
  final Course course;
  final String subjectName;
  final String className;
  const PreviewCourseScreen(
      {Key key,
      @required this.course,
      @required this.subjectName,
      @required this.className})
      : super(key: key);

  @override
  _PreviewCourseScreenState createState() => _PreviewCourseScreenState();
}

class _PreviewCourseScreenState extends State<PreviewCourseScreen> {
  ExtendedCourse extendedCourse;
  @override
  void initState() {
    //
    extendedCourse = ExtendedCourse(
        widget.course.id,
        widget.course.name,
        widget.course.beginTime,
        widget.course.endTime,
        widget.course.studyFee,
        widget.course.daysInWeek,
        widget.course.beginDate,
        widget.course.endDate,
        widget.course.description,
        widget.course.status,
        widget.course.classHasSubjectId,
        widget.course.createdBy,
        widget.course.createdDate,
        widget.course.confirmedDate,
        widget.course.confirmedBy,
        widget.course.maxTutee,
        widget.course.location,
        widget.course.extraImages,
        widget.subjectName,
        widget.className,
        'followDate',
        'enrollmentStatus',
        authorizedTutor.avatarImageLink,
        authorizedTutor.fullname,
        authorizedTutor.email,
        null,
        authorizedTutor.address,
        false,
        widget.course.maxTutee);
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildCourseDetailAppbar(context),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: mainColor,
          onPressed: () {
            //show policy (how much this system take from tutor by commission rate)
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: BlocProvider(
                  create: (BuildContext context) =>
                      CommissionCubit(CommissionRepository()),
                  child: BlocBuilder<CommissionCubit, CommissionState>(
                    builder: (BuildContext context, state) {
                      //
                      final commissionCubit = context.watch<CommissionCubit>();
                      commissionCubit
                          // .getTuteeTransactionByTuteeId(authorizedTutor.id);
                          .getCommissionByCommissionId(1);
                      //
                      if (state is CommissionErrorState) {
                        return ErrorScreen();
                        // return Text(state.errorMessage);
                      } else if (state is CommissionLoadingState) {
                        return buildLoadingIndicator();
                      } else if (state is CommissionLoadedState) {
                        return Container(
                          height: 400,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Image.asset(
                                  'assets/images/1200px-Paper_Plane_Vector.svg.png',
                                  height: 110,
                                ),
                              ),
                              // License term
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: Text(
                                  'License Term',
                                  style: headerStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              //license and policies
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 8,
                                ),
                                child: Text(
                                    'Your course will be verified by managers, all information of this course must be obey our policies.'),
                              ),
                              //
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 8,
                                ),
                                child: Text('Easy Edu would take you ' +
                                    (state.commission.rate * 100).toString() +
                                    ' \% of your total revenue. It means ' +
                                    (double.parse(vars.courseFeeController.text) *
                                            state.commission.rate)
                                        .toString() +
                                    ' \$ each tutee this course has.'),
                              ),
                              //
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  child: Text('Do you agree?'),
                                ),
                              ),

                              //agree and disagree
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Disagree',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: titleFontSize),
                                    ),
                                  ),
                                  //
                                  TextButton(
                                    onPressed: () {
                                      //
                                      extendedCourse.location =
                                          vars.locationController.text.trim();
                                      //set course status from 'isDraft' to 'Pending'
                                      extendedCourse.status = 'Pending';
                                      //
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        return Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateCourseProcessingScreen(
                                              course: extendedCourse,
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    child: Text(
                                      'Agree',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: titleFontSize),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
          label: Text('Publish')),
    );
  }

  Container _buildBody(BuildContext context) {
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
              extendedCourse.name,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: textGreyColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
              onTap: () {},
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
                          extendedCourse.tutorAvatarUrl,
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
                          extendedCourse.tutorName,
                          style: titleStyle,
                        ),
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
          buildcourseInformationListTile(
              extendedCourse.subjectName, 'Subject', Icons.subject),
          buildDivider(),
          //course name
          buildcourseInformationListTile(
              extendedCourse.className, 'Class', Icons.grade),
          buildDivider(),
          //location
          Visibility(
            visible: extendedCourse.location != extendedCourse.tutorAddress,
            child: GestureDetector(
              // onTap: () {
              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => TuteeSearchGoogleMap(
              //             tutoraddress: course.location,
              //             tuteeaddress: _currentAddress,
              //           )));
              // },
              child: buildcourseInformationListTile(
                  extendedCourse.location == extendedCourse.tutorAddress
                      ? 'At Tutor Home'
                      : extendedCourse.location,
                  'Location',
                  Icons.location_on_outlined),
            ),
          ),
          Visibility(
            visible: !(extendedCourse.location != extendedCourse.tutorAddress),
            child: buildcourseInformationListTile(
                extendedCourse.location == extendedCourse.tutorAddress
                    ? 'At Tutor Home'
                    : extendedCourse.location,
                'Location',
                Icons.location_on_outlined),
          ),
          buildDivider(),
          //study time
          buildcourseInformationListTile(
              extendedCourse.beginTime + ' - ' + extendedCourse.endTime,
              'Study Time',
              Icons.access_time),
          buildDivider(),
          //study week days
          buildcourseInformationListTile(
            extendedCourse.daysInWeek
                .replaceFirst('[', '')
                .replaceFirst(']', ''),
            'Days In Week',
            Icons.calendar_today,
          ),
          buildDivider(),
          //begin and end date
          buildcourseInformationListTile(
            extendedCourse.beginDate + ' to ' + extendedCourse.endDate,
            'Begin - End Date',
            Icons.date_range,
          ),
          buildDivider(),
          //price of the course
          buildcourseInformationListTile(
            '\$' + extendedCourse.studyFee.toString(),
            'Study Fee',
            Icons.monetization_on,
          ),
          buildDivider(),
          //maximun tutee in the course
          buildcourseInformationListTile(
            extendedCourse.maxTutee.toString(),
            'Maximum tutee',
            Icons.person,
          ),
          buildDivider(),
          //Available slot(s)
          buildcourseInformationListTile(
            extendedCourse.availableSlot.toString(),
            'Available slot(s)',
            Icons.person,
          ),
          buildDivider(),
          //description for this course
          buildcourseInformationListTile(
            extendedCourse.description != ''
                ? extendedCourse.description
                : 'No description',
            'Extra Information',
            Icons.description,
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
                vars.extraImages.length != 0
                    ? Wrap(
                        runAlignment: WrapAlignment.spaceBetween,
                        runSpacing: 5,
                        spacing: 5,
                        children:
                            List.generate(vars.extraImages.length, (index) {
                          if (index != 0) {
                            //view photo in fullscreen
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imageWidget: Image.file(
                                        vars.extraImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 114,
                                width: 114,
                                child: Image.file(
                                  vars.extraImages[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                      )
                    : Text('No extra images')
              ],
            ),
          ),
          //this widget for being nice only
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  ListTile buildcourseInformationListTile(
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
