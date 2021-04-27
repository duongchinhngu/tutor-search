import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/firebase_functions.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/notification_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_payment/create_course_completed_screen.dart';
import 'package:http/http.dart' as http;
import 'create_course_variables.dart';

class CreateCourseProcessingScreen extends StatelessWidget {
  final Course course;

  const CreateCourseProcessingScreen({Key key, this.course}) : super(key: key);
  //
  Future<bool> completeTutorPayment(Course course) async {
    List<String> extraImagesTmp = [];
    //post Image to DB
    if (extraImages.length > 1) {
      //remove ADD image icon File in default certification image list
      extraImages.remove(extraImages.first);
      //
      for (var certitfication in extraImages) {
        var imageUrl = await uploadFileOnFirebaseStorage(certitfication);
        extraImagesTmp.add(imageUrl);
      }
    }
    course.extraImages = extraImagesTmp.toString();
    //post course
    await CourseRepository().postCourse(course);
    String managerEmail = await CourseRepository()
        .getManagerBySubjectId(http.Client(), course.classHasSubjectId);

    await NotificationRepository().postNotification(
      'Course Status',
      'Have a create course request need to approve!',
      managerEmail,
    );
    //
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completeTutorPayment(course),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            //reset empty for all field in create course screen
            resetEmptyCreateCourseScreen();
            //
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => CreateCourseCompletedScreen()),
                ModalRoute.withName('/Home'),
              );
            });
            return Container();
          } else {
            return Container(
              color: backgroundColor,
              child: SpinKitWave(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red : Colors.green,
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
