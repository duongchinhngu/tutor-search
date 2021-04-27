import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/subject_cubit.dart';
import 'package:tutor_search_system/models/subject.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';
import 'package:tutor_search_system/repositories/subject_repository.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/search_course_screens/filter_models/course_filter_variables.dart'
    as filter_variables;
import 'package:tutor_search_system/screens/tutee_screens/search_course_screens/search_course_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/create_course_screens/create_course_screen.dart';
import 'package:tutor_search_system/states/subject_state.dart';

//default color for background
final defaultWhiteBackground = Colors.white.withOpacity(0.20);
//default text white color
final defautWhiteText = Colors.white.withOpacity(0.8);

String searchValue = '';

class SubjectGridScreen extends StatefulWidget {
  @override
  _SubjectGridScreenState createState() => _SubjectGridScreenState();
}

class _SubjectGridScreenState extends State<SubjectGridScreen> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }
  //login repo
  final loginRepository = LoginRepository();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(
          // vertical: 40,
          horizontal: 10,
        ),
        color: mainColor,
        child: Column(
          children: [
            //'Subject' title
            SubjectsTitle(),
            //subject Grid view;
            //load by cubit and repo
            SubjectGridView(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mainColor,
      elevation: 0.0,
      title: //search by subject box
          SearchSubjectBox(),
      leadingWidth: 20,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.only(left: 15),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  }
}

class SubjectsTitle extends StatelessWidget {
  const SubjectsTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 15,
        left: 20,
        bottom: 15,
      ),
      child: Text(
        'Subjects',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textWhiteColor.withOpacity(0.8),
        ),
      ),
    );
  }
}

//SEARCH BOX
class SearchSubjectBox extends StatefulWidget {
  SearchSubjectBox({
    Key key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged onChanged;

  @override
  _SearchSubjectBoxState createState() => _SearchSubjectBoxState();
}

class _SearchSubjectBoxState extends State<SearchSubjectBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 60,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: 35,
            width: 350,
            margin: EdgeInsets.only(
              top: 15,
              left: 10,
              right: 10,
            ),
            padding: EdgeInsets.only(
              left: 15,
            ),
            decoration: BoxDecoration(
              color: defaultWhiteBackground,
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
                  color: Colors.white.withOpacity(0.7),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search by subject name',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: textFontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//grid view of subject list (all subjects)
class SubjectGridView extends StatefulWidget {
  @override
  _SubjectGridViewState createState() => _SubjectGridViewState();
}

class _SubjectGridViewState extends State<SubjectGridView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectCubit(SubjectRepository()),
      child: BlocBuilder<SubjectCubit, SubjectState>(builder: (context, state) {
        //
        final subjectCubit = context.watch<SubjectCubit>();
        subjectCubit.getSubjectsByStatus(globals.StatusConstants.ACTIVE_STATUS);
        //
        if (state is SubjectLoadingState) {
          return buildLoadingIndicator();
        } else if (state is SubjectLoadFailedState) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is SubjectListLoadedState) {
          //set subjectList var = this state subject list
          state.subjects = state.subjects
              .where((s) => s.name.contains(searchValue))
              .toList();
          //
          //render ui
          return Expanded(
            child: GridView.builder(
              itemCount: state.subjects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => SubjectGridCard(
                subject: state.subjects[index],
              ),
            ),
          );
        }
      }),
    );
  }
}

// Subject card
class SubjectGridCard extends StatelessWidget {
  final Subject subject;

  const SubjectGridCard({Key key, @required this.subject}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //if current user is Tutor => navigate to CreateCOurse screen
        if (globals.authorizedTutor != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCourseScreen(
                selectedSubject: subject,
              ),
            ),
          );
        } else if (globals.authorizedTutee != null) {
          //set filter_variables subject
          filter_variables.filter.filterSubject = subject;
          //navigate to search and filter screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchCourseScreen(),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: defaultWhiteBackground,
        ),
        alignment: Alignment.center,
        child: Text(
          subject.name,
          style: TextStyle(
            fontSize: headerFontSize,
            color: defautWhiteText.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
