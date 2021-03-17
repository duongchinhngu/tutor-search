import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/tutor_transaction.dart';
import 'package:tutor_search_system/repositories/course_repository.dart';
import 'package:tutor_search_system/repositories/membership_repository.dart';
import 'package:tutor_search_system/repositories/transaction_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/create_course_screens/create_course_variables.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_payment/create_course_completed_screen.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:http/http.dart' as http;

//tutor payment processing screen
//this screen process payment; navigate to result screen (error, complete successully; processing)
class TutorPaymentProccessingScreen extends StatefulWidget {
  final TutorTransaction tutorTransaction;
  final Course course;

  const TutorPaymentProccessingScreen(
      {Key key, @required this.tutorTransaction, @required this.course})
      : super(key: key);

  @override
  _TutorPaymentProccessingScreenState createState() =>
      _TutorPaymentProccessingScreenState();
}

class _TutorPaymentProccessingScreenState
    extends State<TutorPaymentProccessingScreen> {
  final transactionRepository = TransactionRepository();
  final courseRepository = CourseRepository();

//
  Future<bool> completeTutorPayment(
      TutorTransaction tuteeTransaction, Course course) async {
    //get membership of this auth tutor
    await MembershipRepository()
        .fetchMembershipByMembershipId(
            http.Client(), globals.authorizedTutor.membershipId)
        .then((membership) => {
              //update achieve points
              //point save is pointRate nhan voi total amount: so tien ma sau khi tru di point use
              widget.tutorTransaction.archievedPoints =
                  (widget.tutorTransaction.totalAmount * membership.pointRate)
                      .round(),
              //reset new value to authorizeTutor
              //then update this authorized tutor to DB
              // //
              globals.authorizedTutor.points = globals.authorizedTutor.points -
                  widget.tutorTransaction.usedPoints +
                  widget.tutorTransaction.archievedPoints,
            });
    //post tutor transaction
    await transactionRepository.postTutorTransaction(widget.tutorTransaction);
    //post course
    await courseRepository.postCourse(course);
    //update this tutor in DB
    await TutorRepository().putTutor(globals.authorizedTutor);
    //
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completeTutorPayment(widget.tutorTransaction, widget.course),
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
