//complete tutor transaction
import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/braintree_payment_functions.dart';
import 'package:tutor_search_system/models/braintree.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/fee.dart';
import 'package:tutor_search_system/models/tutor_transaction.dart';
import 'package:tutor_search_system/repositories/braintree_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';
import 'tutor_payment_processing.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;

//show payment method: credit card ỏ debit card or Paypal
Future checkOutTutorPayment(BuildContext context, Course course,
    double totalAmount, int usedPoint, Fee fee) async {
  //get braintree client token and prepare braintree model
  Braintree braintree = await prepareBraintreeCheckOut(totalAmount);
  //doCheckout() method
  await BraintreeRepository().checkOut(braintree).then((result) {
    if (result) {
      //show payment(check out message)
      ScaffoldMessenger.of(context).showSnackBar(
        buildDefaultSnackBar(
          Icons.check_circle_outline_outlined,
          'Payment completed!',
          'Check out successfully.',
          completedColor,
        ),
      );
      //init model and navigate to process screen
      if (globals.authorizedTutor != null) {
        //post TuteeTransaction
        _completeTutorTransaction(context, course, totalAmount, usedPoint, fee);
      }
    } else {
      //show alert undeconstruction
      showDialog(
        context: context,
        builder: (context) => buildDefaultDialog(
          context,
          'Under Construction!',
          'PayPal payment will be soon.',
          [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            )
          ],
        ),
      );
    }
  });
  //
}

//
void _completeTutorTransaction(BuildContext context, Course course,
    double totalAmount, int usePoint, Fee fee) async {
//init tutorTransaction
  final tutorTransaction = TutorTransaction.modelConstructor(
      0,
      globals.defaultDatetime,
      fee.price,
      totalAmount,
      '',
      //temporary status
      'Successful',
      //feeId
      fee.id,
      //achievedPoint
      0,
      //used points
      usePoint,
      //need to refactor
      globals.authorizedTutor.id);
  // 0,
  // '1900-01-01',
  // course.studyFee,
  // totalAmount,
  // '',
  // 'Successfull',
  // globals.tuteeId,
  // 1);
  //
  WidgetsBinding.instance.addPostFrameCallback((_) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TutorPaymentProccessingScreen(
          tutorTransaction: tutorTransaction,
          course: course,
        ),
      ),
    );
  });
}
