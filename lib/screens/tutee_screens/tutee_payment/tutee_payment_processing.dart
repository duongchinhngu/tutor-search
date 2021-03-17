import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/models/enrollment.dart';
import 'package:tutor_search_system/models/tutee_transaction.dart';
import 'package:tutor_search_system/repositories/enrollment_repository.dart';
import 'package:tutor_search_system/repositories/transaction_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_payment/follow_completed_screen.dart';


//tutee payment processing screen
//this screen process payment; navigate to result screen (error, complete successully; processing)
class TuteePaymentProccessingScreen extends StatefulWidget {
  final TuteeTransaction tuteeTransaction;
  final Enrollment enrollment;

  const TuteePaymentProccessingScreen(
      {Key key, @required this.tuteeTransaction, @required this.enrollment})
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
    await tuteeTransactionRepository
        .postTuteeTransaction(widget.tuteeTransaction);
    await enrollmentRepository.postEnrollment(enrollment);
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