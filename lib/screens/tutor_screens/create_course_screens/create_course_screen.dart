import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/class_cubit.dart';
import 'package:tutor_search_system/models/class_has_subject.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/subject.dart';
import 'package:tutor_search_system/repositories/class_has_subject_repository.dart';
import 'package:tutor_search_system/repositories/class_repository.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/screens/common_ui/payment_screens.dart/payment_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutor_screens/create_course_screens/week_days_ui.dart';
import 'package:tutor_search_system/states/class_state.dart';

import 'create_course_elements.dart';

//this is default course (when tutor does not choose fields for new course)
//default value of unchosen field is "No Select"
// final c = Course.constructor(id, name, beginTime, endTime, studyForm, studyFee, daysInWeek, beginDate, endDate, description, status, classHasSubjectId, createdBy, confirmBy, createdDate, confirmedDate)
Course course = Course.constructor(
  0,
  // name
  '',
  //begintime
  'No select',
  // endtime
  'No select',
  //study form
  'No select',
  //study fee
  null,
  //days in week
  '[]',
  //begin date
  'No select',
  // end date
  'No select',
  //description
  '',
  //status
  'isDraft',
  //class has subject
  //this is hard code need to refactor
  0,
  //thi sis hard code
  //createdBy
  globals.tutorId,
  // confirmBy
  //this is fake manager id (confirmedBy); backend handles this field
  0,
  //createddate
  globals.defaultDatetime,
  //confirm date
  //this is fake confirmedDate; backend handles this field
  globals.defaultDatetime,
);

//selectedClassName
String selectedClassName = 'No select';

//course name field controller
TextEditingController _courseNameController = TextEditingController();
TextEditingController _courseFeeController = TextEditingController();
TextEditingController _courseDescriptionController = TextEditingController();

//create course UI;
//this is main ui
class CreateCourseScreen extends StatefulWidget {
  final Subject selectedSubject;

  const CreateCourseScreen({Key key, @required this.selectedSubject})
      : super(key: key);
  @override
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  //validator for all input field
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 25,
            color: textGreyColor,
          ),
          onPressed: () {
            selectedClassName = 'No select';
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (formkey.currentState.validate()) {
                formkey.currentState.save();
                course.showAttributes(course);
                if (course.classHasSubjectId == 0 ||
                    course.studyForm == 'No select' ||
                    course.beginDate == 'No select' ||
                    course.beginTime == 'No select' ||
                    course.endTime == 'No select' ||
                    course.daysInWeek == '[]') {
                  showDialog(
                      context: context,
                      builder: (context) => buildAlertDialog(context));
                } else {
                  //set course status from 'isDraft' to 'Pending'
                  course.status = 'Pending';
                  //thi sis for test only
                  final courseRepository = CourseRepository();
                  // await courseRepository.postCourse(course);
                  //pri
                  //navigate to payment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(course: course),
                    ),
                  );
                }
              }
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: mainColor,
                  )),
              child: Text(
                'Publish',
                style: TextStyle(
                  color: mainColor,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.blueAccent,
        child: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.only(
              top: 20,
            ),
            children: [
              //
              Container(
                height: 320,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [boxShadowStyle],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //course name input
                    ListTile(
                      leading: Container(
                        width: 43,
                        height: 43,
                        child: Icon(
                          Icons.library_books,
                          color: mainColor,
                        ),
                      ),
                      title: TextFormField(
                        controller: _courseNameController,
                        maxLength: 100,
                        textAlign: TextAlign.start,
                        onChanged: (context) {
                          //set name = value of this textFormfield on change
                          setState(() {
                            course.name = _courseNameController.text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Course name',
                          labelStyle: textStyle,
                          fillColor: Color(0xffF9F2F2),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.0),
                          ),
                          hintText: 'What should we call your couse',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: textFontSize,
                          ),
                        ),
                        validator: RequiredValidator(
                            errorText: "Course name is required"),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 30,
                      endIndent: 20,
                    ),
                    //class bottom up
                    ListTile(
                      leading: Container(
                        width: 43,
                        height: 43,
                        child: Icon(
                          Icons.grade,
                          color: mainColor,
                        ),
                      ),
                      title: Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          bottom: 5,
                        ),
                        child: Text(
                          'Class',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () {
                          classSelector(context, widget.selectedSubject);
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                selectedClassName,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  color: textGreyColor,
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: mainColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //subject
                    ListTile(
                      leading: Container(
                        width: 43,
                        height: 43,
                        child: Icon(
                          Icons.subject,
                          color: mainColor,
                        ),
                      ),
                      title: Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          bottom: 5,
                        ),
                        child: Text(
                          'Subject',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.selectedSubject.name,
                            style: TextStyle(
                                fontSize: titleFontSize,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //study form
              Container(
                height: 120,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(right: 20, top: 20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [boxShadowStyle],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 43,
                    height: 43,
                    child: Icon(
                      Icons.school,
                      color: mainColor,
                    ),
                  ),
                  title: Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 5,
                    ),
                    child: Text(
                      'Study form',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  subtitle: InkWell(
                    onTap: () {
                      studyFormSelector(context);
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            offset: Offset(1, 1),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            course.studyForm,
                            style: TextStyle(
                                fontSize: titleFontSize, color: textGreyColor),
                          ),
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: mainColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //begin date - end date
              GestureDetector(
                onTap: () async {
                  //date range;
                  //from date range get start date and end date
                  final range = await dateRangeSelector(context);

                  //set end and start date
                  setEndAndBeginDate(range);
                },
                child: Container(
                  height: 210,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(left: 20, top: 20),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [boxShadowStyle],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //edit icon
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: mainColor,
                        ),
                      ),
                      //begin date
                      ListTile(
                        minLeadingWidth: 20,
                        leading: Icon(
                          Icons.calendar_today,
                          color: mainColor,
                        ),
                        title: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            'Begin date',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500]),
                          ),
                        ),
                        subtitle: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Text(
                            course.beginDate,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: textGreyColor,
                            ),
                          ),
                        ),
                      ),
                      // end date
                      ListTile(
                        minLeadingWidth: 20,
                        leading: Icon(
                          Icons.calendar_today,
                          color: mainColor,
                        ),
                        title: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            'End date',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500]),
                          ),
                        ),
                        subtitle: Container(
                          height: 50,
                          width: 100,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Text(
                            course.endDate,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: textGreyColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //begin time - end time
              GestureDetector(
                onTap: () async {
                  //select time range
                  final TimeRange timeRange = await timeRangeSelector(context);
                  //set tmpCourse begin and end time
                  // setBeginAndEndTime(timeRange);
                },
                child: Container(
                  height: 210,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(right: 20, top: 20),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [boxShadowStyle],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //icon edit time
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: mainColor,
                        ),
                      ),
                      //begin time
                      ListTile(
                        leading: Container(
                          width: 43,
                          height: 43,
                          child: Icon(
                            Icons.access_time,
                            color: mainColor,
                          ),
                        ),
                        title: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            'Begin time',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500]),
                          ),
                        ),
                        subtitle: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              course.beginTime,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: textGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //end time
                      ListTile(
                        leading: Container(
                          width: 43,
                          height: 43,
                          child: Icon(
                            Icons.access_time,
                            color: mainColor,
                          ),
                        ),
                        title: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            'End time',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500]),
                          ),
                        ),
                        subtitle: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              course.endTime,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: textGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //week days selector
              Container(
                height: 200,
                width: 200,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(left: 20, top: 20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [boxShadowStyle],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  minLeadingWidth: 20,
                  title: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: mainColor,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            'Days in week',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: WeekDaysComponent(),
                ),
              ),
              //study fee
              Container(
                height: 120,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(right: 20, top: 20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [boxShadowStyle],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 43,
                    height: 43,
                    child: Icon(
                      Icons.monetization_on,
                      color: mainColor,
                    ),
                  ),
                  title: TextFormField(
                    controller: _courseFeeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.start,
                    onChanged: (context) {
                      setState(() {
                        course.studyFee =
                            double.parse(_courseFeeController.text);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Study Fee',
                      labelStyle: textStyle,
                      fillColor: Color(0xffF9F2F2),
                      filled: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.0),
                      ),
                      hintText: 'Fee/Tutee',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: textFontSize,
                      ),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Study Fee is required"),
                    ]),
                  ),
                ),
              ),
              // Description
              Container(
                height: 200,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [boxShadowStyle],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 43,
                    // height: 43,
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: mainColor,
                    ),
                  ),
                  title: TextFormField(
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    maxLength: 500,
                    maxLines: null,
                    controller: _courseDescriptionController,
                    textAlign: TextAlign.start,
                    onChanged: (context) {
                      setState(() {
                        course.description = _courseDescriptionController.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Description (optional)',
                      labelStyle: textStyle,
                      fillColor: Color(0xffF9F2F2),
                      filled: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.0),
                      ),
                      hintText: 'Extra information about this course..',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: textFontSize,
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

//show modal and choose begin and end time
  timeRangeSelector(BuildContext context) {
    showTimeRangePicker(
      context: context,
      padding: 30,
      interval: Duration(minutes: 10),
      strokeWidth: 10,
      handlerRadius: 10,
      strokeColor: mainColor,
      handlerColor: mainColor,
      selectedColor: Colors.red[900],
      onEndChange: (end) {
        setState(() {
          course.endTime = globals.timeFormatter
              .format(new DateTime(1990, 1, 1, end.hour, end.minute, 0));
        });
      },
      onStartChange: (start) {
        setState(() {
          course.beginTime = globals.timeFormatter
              .format(new DateTime(1990, 1, 1, start.hour, start.minute, 0));
        });
      },
      backgroundWidget: Text(
        'Study Time',
        style: GoogleFonts.kaushanScript(
          textStyle: TextStyle(
            color: mainColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ticks: 12,
      ticksColor: Colors.white,
      snap: true,
      labels: [
        ClockLabel(angle: 270.0 * pi / 180, text: '12AM'),
        ClockLabel(angle: 00.0, text: '6PM'),
        ClockLabel(angle: 90.0 * pi / 180, text: 'Midnight'),
        ClockLabel(angle: 180.0 * pi / 180, text: '6AM')
      ],
    );
  }

  //get date range and get end and start date
  Future<DateTimeRange> dateRangeSelector(BuildContext context) {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        new Duration(
          days: 365,
        ),
      ),
    );
  }

  //setstate for tmpcourse end and begin date
  void setEndAndBeginDate(DateTimeRange range) {
    //set tmpCourse.beginDate = start date
    if (range.start != null) {
      setState(() {
        course.beginDate = globals.dateFormatter.format(range.start);
      });
    }

    //set tmpCourse.endDate = end date
    if (range.end != null) {
      setState(() {
        course.endDate = globals.dateFormatter.format(range.end);
      });
    }
  }

//select study form;
// this will be shown when press studyform
  Future<dynamic> studyFormSelector(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            children: [
              // study online
              ListTile(
                leading: SizedBox(
                  width: 50,
                ),
                title: Text(
                  'Online',
                  style: TextStyle(
                    color: textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectStudyForm('Online');
                  });
                },
              ),
              //study at tutee home
              ListTile(
                leading: SizedBox(
                  width: 50,
                ),
                title: Text(
                  'Tutee Home',
                  style: TextStyle(
                    color: textGreyColor,
                    fontSize: titleFontSize,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectStudyForm('Tutee Home');
                  });
                },
              )
            ],
          );
        });
  }

  //select and set state of study form in default course
  _selectStudyForm(String studyForm) {
    Navigator.pop(context);
    setState(() {
      course.studyForm = studyForm;
    });
  }

//load all classes by api
  Future<dynamic> classSelector(BuildContext context, Subject subject) =>
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: BlocProvider(
                create: (context) => ClassCubit(ClassRepository()),
                child: BlocBuilder<ClassCubit, ClassState>(
                  builder: (context, state) {
                    //
                    final classCubit = context.watch<ClassCubit>();
                    classCubit.getClassBySubjectId(subject.id);
                    //
                    if (state is ClassLoadingState) {
                      return buildLoadingIndicator();
                    } else if (state is ClassesLoadFailedState) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else if (state is ClassListLoadedState) {
                      return Container(
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          itemCount: state.classes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: SizedBox(
                                width: 50,
                              ),
                              title: Text(
                                state.classes[index].name,
                                style: TextStyle(
                                  color: textGreyColor,
                                  fontSize: titleFontSize,
                                ),
                              ),
                              onTap: () async {
                                //call api;
                                //load classHasSubjectId by ClassId and SubjectId
                                //then set tmpCourse.classhasSubject = result
                                final classHasSubjectRepository =
                                    ClassHasSubjectRepository();
                                final ClassHasSubject classHasSubject =
                                    await classHasSubjectRepository
                                        .fetchClassHasSubjectBySubjectIdClassId(
                                            http.Client(),
                                            subject.id,
                                            state.classes[index].id);
                                //
                                Navigator.pop(context);
                                setState(() {
                                  course.classHasSubjectId = classHasSubject.id;
                                  selectedClassName = state.classes[index].name;
                                });
                                print('this is id of class subject: ' + course.classHasSubjectId.toString());
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          });
}
