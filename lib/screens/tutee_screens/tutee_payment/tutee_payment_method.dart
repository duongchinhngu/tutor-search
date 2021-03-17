import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/braintree_payment_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:tutor_search_system/models/braintree.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/models/enrollment.dart';
import 'package:tutor_search_system/models/tutee_transaction.dart';
import 'package:tutor_search_system/repositories/braintree_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';
import 'tutee_payment_processing.dart';

//show payment method: credit card ỏ debit card or Paypal
Future checkOutTuteePayment(
    BuildContext context, Course course, double totalAmount) async {
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
      if (globals.authorizedTutee != null) {
        //post TuteeTransaction
        _completeTuteeTransaction(context, course, totalAmount);
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

//complete tutee transaction
void _completeTuteeTransaction(
    BuildContext context, Course course, double totalAmount) {
//init tuteeTransaction
  final tuteeTransaction = TuteeTransaction.modelConstructor(
    0,
    '1900-01-01',
    course.studyFee,
    totalAmount,
    '',
    'Successfull',
    globals.authorizedTutee.id,
    1,
  );
  //init enrollment
  final enrollment = Enrollment.modelConstructor(
    0,
    globals.authorizedTutee.id,
    course.id,
    'Waiting for acception from Tutor of this course',
    'Pending',
  );
  //
  WidgetsBinding.instance.addPostFrameCallback((_) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TuteePaymentProccessingScreen(
          tuteeTransaction: tuteeTransaction,
          enrollment: enrollment,
        ),
      ),
    );
  });
}
