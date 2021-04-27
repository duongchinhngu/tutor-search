import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/braintree_payment_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:tutor_search_system/models/braintree.dart';
import 'package:tutor_search_system/models/enrollment.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/models/tutee_transaction.dart';
import 'package:tutor_search_system/repositories/braintree_repository.dart';
import 'package:tutor_search_system/repositories/commission_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';
import 'tutee_payment_processing.dart';

//show payment method: credit card ỏ debit card or Paypal
Future checkOutTuteePayment(BuildContext context, ExtendedCourse course,
    double totalAmount, Enrollment enrollment) async {
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
        _completeTuteeTransaction(context, course, totalAmount, enrollment);
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
Future<void> _completeTuteeTransaction(BuildContext context,
    ExtendedCourse course, double totalAmount, Enrollment enrollment) async {
  //get join course commission
  final commission = await CommissionRepository().fetchCommissionByCommissionId(
      http.Client(), globals.JOIN_COURSE_COMMISSION_ID);
//init tuteeTransaction
  final tuteeTransaction = TuteeTransaction.modelConstructor(
      0,
      '2021-04-23',
      totalAmount,
      '',
      'Successful',
      globals.authorizedTutee.id,
      commission.id,
      course.id,
      course.studyFee,
      commission.rate,
      'Join course payment');
  //
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
