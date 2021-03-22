import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/class_cubit.dart';
import 'package:tutor_search_system/cubits/course_cubit.dart';
import 'package:tutor_search_system/models/class.dart';
import 'package:tutor_search_system/models/subject.dart';
import 'package:tutor_search_system/repositories/class_repository.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/home_screens/tutee_home_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/search_course_screens/filter_models/course_filter_variables.dart';
import 'package:tutor_search_system/states/class_state.dart';
import 'package:tutor_search_system/states/course_state.dart';
import 'course_filter_popup.dart';

//number of filter item selected
int numberOfSelected = 0;
//
String searchValue = '';

class SearchCourseScreen extends StatefulWidget {
  @override
  _SearchCourseScreenState createState() => _SearchCourseScreenState();
}

class _SearchCourseScreenState extends State<SearchCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchCourseAppBar(context),
      body: Container(
        color: mainColor,
        child: Column(
          children: [
            //horizontal class list
            SearchCourseBody(
              subject: filter.filterSubject,
            ),
            //
            // result of subject and class
          ],
        ),
      ),
    );
  }

  //appbar
  AppBar buildSearchCourseAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: buildDefaultBackButton(context),
      elevation: 1.0,
      actions: [
        //filter icon button
        GestureDetector(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseFilterPopup()))
                .then((value) => setState(() => {
                      value != null
                          ? numberOfSelected = value
                          : numberOfSelected = numberOfSelected,
                    }));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              //filter icon
              Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  right: 25,
                ),
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/images/ic_filter-horizontal-512.png',
                  height: 23,
                  width: 23,
                  color: numberOfSelected != 0 ? mainColor : textGreyColor,
                ),
              ),
              //filter item count
              Visibility(
                visible: numberOfSelected != 0,
                child: CircleAvatar(
                  backgroundColor: mainColor,
                  radius: 8,
                  child: Text(
                    numberOfSelected.toString(),
                    style: TextStyle(
                      color: textWhiteColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
      title: SearchBox(),
      centerTitle: true,
    );
  }
}

//SEARCH BOX
class SearchBox extends StatefulWidget {
  SearchBox({
    Key key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged onChanged;

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 60,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: 35,
        width: 350,
        margin: EdgeInsets.only(
          top: 15,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          textAlign: TextAlign.start,
          onChanged: (value) {
            setState(() {
              searchValue = value;
            });
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 13),
            icon: Icon(
              Icons.search,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Search by course name',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: textFontSize,
            ),
          ),
        ),
      ),
    );
  }
}

//horizontal class list and course result below
class SearchCourseBody extends StatefulWidget {
  final Subject subject;

  const SearchCourseBody({Key key, @required this.subject}) : super(key: key);
  @override
  _SearchCourseBodyState createState() => _SearchCourseBodyState();
}

//Search Course body contain class horizontal list and course result
class _SearchCourseBodyState extends State<SearchCourseBody> {
  @override
  void initState() {
    super.initState();
    print('this is selected weekdays: ' + filter.filterWeekdays.toString());
    if (filter.filterClass != null) {
      filter.filterClass = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassCubit(ClassRepository()),
      child:
          // ignore: missing_return
          BlocBuilder<ClassCubit, ClassState>(builder: (context, state) {
        //call class cubit and get all classes by subject id
        final classCubit = context.watch<ClassCubit>();
        classCubit.getClassBySubjectIdStatus(widget.subject.id, StatusConstants.ACTIVE_STATUS);
        //render proper UI for each classes state
        if (state is ClassLoadingState) {
          return buildLoadingIndicator();
        } else if (state is ClassListLoadedState) {
          //setdefault seelcted class when filter class is null
          if (filter.filterClass == null) {
            filter.filterClass = state.classes.first;
          }
          //load all classes by subject id
          return buildClassHorizontalListAndCourseResult(state);
        } else if (state is ClassesLoadFailedState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
      }),
    );
  }

  //course result search; class horizontal listview
  Expanded buildClassHorizontalListAndCourseResult(ClassListLoadedState state) {
    return Expanded(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            //list all available classes
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.classes.length,
                itemBuilder: (context, index) {
                  return buildClassesHorizontal(index, state.classes[index]);
                },
              ),
            ),
            // //show course gridview by subject id and class id
            BlocProvider(
              create: (context) => CourseCubit(CourseRepository()),
              child: BlocBuilder<CourseCubit, CourseState>(
                builder: (context, state) {
                  //
                  final courseCubit = context.watch<CourseCubit>();
                  courseCubit.getCoursesByFilter(filter);
                  //render proper UI for each Course state
                  if (state is CourseLoadingState) {
                    return buildLoadingIndicator();
                  } else if (state is CourseListLoadedState) {
                    //set subjectList var = this state subject list
                    state.courses = state.courses
                        .where((s) => s.name.contains(searchValue))
                        .toList();
                    //load all course and then load courses by class id
                    return Expanded(child: buildCourseGridView(state));
                  } else if (state is CourseLoadFailedState) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else if (state is CourseNoDataState) {
                    return NoDataScreen();
                  }
                },
              ),
            )
            // // buildCourseGridView(state),
          ],
        ),
      ),
    );
  }

// horizotal Classes ui
  GestureDetector buildClassesHorizontal(int index, Class classes) {
    return GestureDetector(
        onTap: () {
          setState(() {
            //setstate current selected class
            filter.filterClass = classes;
          });
        },
        child: Container(
          width: 110,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                classes.name,
                style: TextStyle(
                  color: filter.filterClass.id == classes.id
                      ? mainColor
                      : textGreyColor,
                  fontSize: titleFontSize,
                ),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: filter.filterClass.id == classes.id
                    ? mainColor
                    : Colors.transparent,
                thickness: 1,
              ),
            ],
          ),
        ));
  }
}
