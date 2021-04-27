import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/models/enrollment.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/models/tutee_transaction.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/notification_repository.dart';
import 'package:tutor_search_system/repositories/transaction_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_payment/follow_completed_screen.dart';
import 'package:http/http.dart' as http;

//tutee payment processing screen
//this screen process payment; navigate to result screen (error, complete successully; processing)
class TuteePaymentProccessingScreen extends StatefulWidget {
  final TuteeTransaction tuteeTransaction;
  final Enrollment enrollment;
  final ExtendedCourse course;

  const TuteePaymentProccessingScreen(
      {Key key,
      @required this.tuteeTransaction,
      @required this.enrollment,
      @required this.course})
      : super(key: key);
  @override
  _TuteePaymentProccessingScreenState createState() =>
      _TuteePaymentProccessingScreenState();
}

class _TuteePaymentProccessingScreenState
    extends State<TuteePaymentProccessingScreen> {
  final tuteeTransactionRepository = TransactionRepository();
  final enrollmentRepository = EnrollmentRepository();

  Future<bool> completePayment(
      TuteeTransaction tuteeTransaction, Enrollment enrollment) async {
    //
    await tuteeTransactionRepository
        .postTuteeTransaction(widget.tuteeTransaction);
    //
    await enrollmentRepository.postEnrollment(enrollment);

    ExtendedCourse extendedCourse = await CourseRepository()
        .fetchCourseByCourseId(http.Client(), widget.enrollment.courseId);
    String tutorEmail = extendedCourse.tutorEmail;

    await NotificationRepository().postNotification(
        extendedCourse.name, 'Have a new enrollment to course', tutorEmail);
    // //
    // await enrollmentRepository.checkFullCourse(enrollment.courseId);
    // //
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completePayment(widget.tuteeTransaction, widget.enrollment),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => FollowCompletedScreen()),
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
