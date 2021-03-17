import 'package:flutter/cupertino.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/screens/tutee_screens/search_course_screens/filter_fields/filter_class_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/search_course_screens/filter_fields/filter_string_fields_screen.dart';
import 'filter_models/course_filter_variables.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart' as converter;
import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/screens/common_ui/common_buttons.dart';
import 'package:tutor_search_system/screens/common_ui/common_popups.dart';
import 'filter_models/filter_item.dart' as filter_items;
import 'search_course_screen.dart' as search_screen;
import 'filter_models/filter_item.dart';

class CourseFilterPopup extends StatefulWidget {
  @override
  _CourseFilterPopupState createState() => _CourseFilterPopupState();
}

class _CourseFilterPopupState extends State<CourseFilterPopup> {
  //set end and begin time ui
  void setBeginAndEndTime(TimeRange timeRange) {
    //set start time if not null
    if (timeRange != null) {
      setState(() {
        filter.filterTimeRange = timeRange;
      });
    }
  }

  //set begin and end date at course filter variables
  void setBeginAndEndDate(DateTimeRange dateRange) {
    //set start time if not null
    if (dateRange.start != null && dateRange.end != null) {
      setState(() {
        filter.filterDateRange = dateRange;
      });
    }
  }

  //reset all filter fields
  void reset() {
    setState(() {
      //reset filter vars
      filter.resetFilterVariables();
      //reset filter item
      filter_items.resetToDefaultValue();
      //reset nunmberofselectedFilteritem in search course screen
      search_screen.numberOfSelected = 0;
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildFilterAppBar(context),
      body: Container(
        color: backgroundColor,
        width: double.infinity,
        child: ListView(
          children: [
            //study time
            buildFilterFieldListTitle(
              filter.filterTimeRange != null,
              'Study Time',
              filter.filterTimeRange != null
                  ? converter.convertTimeOfDayToString(
                          filter.filterTimeRange.startTime) +
                      ' - ' +
                      converter.convertTimeOfDayToString(
                          filter.filterTimeRange.endTime)
                  : '',
              () async {
                //default dateRange
                TimeRange defaultTimeRange;
                if (filter.filterTimeRange != null) {
                  defaultTimeRange = filter.filterTimeRange;
                }
                //choose time range
                final timeRange = await timeRangeSelector(
                    context, defaultTimeRange, 'Study time');
                //set filter item this time range
                setBeginAndEndTime(timeRange);
              },
              false,
            ),
            Divider(),
            //study form
            buildFilterFieldListTitle(
              filter.filterStudyForm != null,
              'Study Form',
              filter.filterStudyForm != null ? filter.filterStudyForm : '',
              () async {
                //navigator to new page from right to left
                Route route = CupertinoPageRoute(
                  builder: (context) => FilterForStringFieldScreen(
                    filterItems: filter_items.studyForms,
                    header: 'Study Form',
                    isMultipleSelectable: false,
                  ),
                );
                //
                final selectedValue = await Navigator.push(context, route);
                //set filter variable
                setState(() {
                  filter.filterStudyForm = selectedValue;
                });
              },
              true,
            ),
            Divider(),
            //study fee
            buildFilterFieldListTitle(
              filter.filterStudyFee != null,
              'Study Fee',
              filter.filterStudyFee != null
                  ? '\$' +
                      filter.filterStudyFee.from.toString() +
                      ' - ' +
                      '\$' +
                      filter.filterStudyFee.to.toString()
                  : '',
              () async {
                //navigator to new page from right to left
                Route route = CupertinoPageRoute(
                  builder: (context) => FilterForStringFieldScreen(
                    filterItems: feeRanges,
                    header: 'Study Fee',
                    isMultipleSelectable: false,
                  ),
                );
                //
                final selectedValue = await Navigator.push(context, route);
                //set filter variable = new object
                setState(() {
                  if (selectedValue == feeRangeContent1) {
                    filter.filterStudyFee = FilterStudyFee(0, 25);
                  } else if (selectedValue == feeRangeContent2) {
                    filter.filterStudyFee = FilterStudyFee(25, 50);
                  } else if (selectedValue == feeRangeContent3) {
                    filter.filterStudyFee = FilterStudyFee(50, double.infinity);
                  }
                });
              },
              true,
            ),
            Divider(),
            //days in week
            buildFilterFieldListTitle(
              filter.filterWeekdays.isNotEmpty,
              'Weekday',
              filter.filterWeekdays.isNotEmpty ? filter.filterWeekdays : '',
              () async {
                //navigator to new page from right to left
                Route route = CupertinoPageRoute(
                  builder: (context) => FilterForStringFieldScreen(
                    filterItems: weekdays,
                    header: 'Weekday',
                    isMultipleSelectable: true,
                  ),
                );
                //
                final selectedValue =
                    await Navigator.push(context, route) as List<String>;
                //
                if (selectedValue != null) {
                  setState(() {
                    filter.filterWeekdays = selectedValue
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', '');
                  });
                }
              },
              true,
            ),
            Divider(),
            //begin date - end date selector
            buildFilterFieldListTitle(
              filter.filterDateRange != null,
              'Begin Date - End Date',
              filter.filterDateRange != null
                  ? converter.convertDayTimeToString(
                          filter.filterDateRange.start) +
                      '       to      ' +
                      converter
                          .convertDayTimeToString(filter.filterDateRange.end)
                  : '',
              () async {
                //default dateRange
                DateTimeRange defaultDateRange;
                if (filter.filterDateRange != null) {
                  defaultDateRange = filter.filterDateRange;
                }
                //choose date range
                final dateRange =
                    await dateRangeSelector(context, defaultDateRange);
                //set filter item this date range
                setBeginAndEndDate(dateRange);
              },
              false,
            ),
            Divider(),
            //class
            buildFilterFieldListTitle(
              filter.filterClass != null,
              'Class',
              filter.filterClass != null ? filter.filterClass.name : '',
              () async {
                //navigator to new page from right to left
                Route route = CupertinoPageRoute(
                  builder: (context) => FilterClassSelectorScreen(),
                );
                //
                final selectedValue = await Navigator.push(context, route);
                //
                if (selectedValue != null) {
                  setState(() {
                    filter.filterClass = selectedValue;
                  });
                }
              },
              true,
            ),
            Divider(),
            // //gender
            buildFilterFieldListTitle(
              filter.filterGender != null,
              'Gender',
              filter.filterGender != null ? filter.filterGender : '',
              () async {
                //navigator to new page from right to left
                Route route = CupertinoPageRoute(
                  builder: (context) => FilterForStringFieldScreen(
                    filterItems: genders,
                    header: 'Gender',
                    isMultipleSelectable: false,
                  ),
                );
                //
                final selectedValue = await Navigator.push(context, route);
                //set filter variable gender
                setState(() {
                  filter.filterGender = selectedValue;
                });
              },
              true,
            ),
            Divider(),
          ],
        ),
      ),
      bottomNavigationBar: buildApplyFAB(),
    );
  }

//appbar
  AppBar buildFilterAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 1,
      title: Text(
        'Filters',
        style: titleStyle,
      ),
      centerTitle: true,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            reset();
          },
          child: Text(
            'Reset',
            style: textStyle,
          ),
        ),
      ],
      leading: buildDefaultCloseButton(context),
    );
  }

//filter field UI
  ListTile buildFilterFieldListTitle(bool isFilterFieldNotNull, String title,
      String subtitle, Function press, bool hasIcon) {
    if (isFilterFieldNotNull) {
      //list title with subtitle is our chooses
      return ListTile(
        title: Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: isFilterFieldNotNull ? mainColor : textGreyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Visibility(
          visible: isFilterFieldNotNull,
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: textFontSize,
              color: mainColor,
            ),
          ),
        ),
        trailing: Visibility(
          visible: hasIcon,
          child: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ),
        onTap: press,
      );
    } else {
      //list tile with no subtitle
      return ListTile(
        title: Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: isFilterFieldNotNull ? mainColor : textGreyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: Visibility(
          visible: hasIcon,
          child: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ),
        onTap: press,
      );
    }
  }

//see result Floating bottom appbar
  InkWell buildApplyFAB() {
    return InkWell(
      onTap: () {
        print('this is weekdays filter: ' + filter.filterWeekdays.toString());
        Navigator.pop(context, filter.countSelectedFilterItems());
      },
      child: BottomAppBar(
        color: mainColor,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          child: Text(
            'See Results',
            style: TextStyle(
              color: backgroundColor,
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 1,
      ),
    );
  }
}
