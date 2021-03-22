import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/class_cubit.dart';
import 'package:tutor_search_system/repositories/class_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/states/class_state.dart';
import '../filter_models/course_filter_variables.dart';

class FilterClassSelectorScreen extends StatefulWidget {
  @override
  _FilterClassSelectorScreenState createState() =>
      _FilterClassSelectorScreenState();
}

class _FilterClassSelectorScreenState extends State<FilterClassSelectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildFilterClassAppBar(context),
      body: BlocProvider(
        create: (context) => ClassCubit(ClassRepository()),
        child: BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            //
            final classCubit = context.watch<ClassCubit>();
            final subjectId = filter.filterSubject.id;
            classCubit.getClassBySubjectIdStatus(subjectId, StatusConstants.ACTIVE_STATUS);
            //
            if (state is ClassLoadingState) {
              return buildLoadingIndicator();
            } else if (state is ClassesLoadFailedState) {
              return Center(
                child: Text('Error: ' + state.errorMessage),
              );
            } else if (state is ClassListLoadedState) {
              return Container(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: state.classes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Visibility(
                        visible: filter.filterClass.id ==
                            state.classes[index].id,
                        child: Icon(
                          Icons.check,
                          color: mainColor,
                          size: 15,
                        ),
                      ),
                      title: Text(
                        state.classes[index].name,
                        style: TextStyle(
                          color: filter.filterClass.id ==
                                  state.classes[index].id
                              ? mainColor
                              : textGreyColor,
                          fontSize: titleFontSize,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filter.filterClass = state.classes[index];
                        });
                        Navigator.pop(context, state.classes[index]);
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
  }

  AppBar buildFilterClassAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 1,
      title: Text(
        'Class',
        style: titleStyle,
      ),
      centerTitle: true,
      leading: buildDefaultBackButton(context),
    );
  }
}
