import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/models/enrollment.dart';
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_payment/tutor_payment_screen.dart';
import 'tutee_payment_method.dart' as payment_methods;

//
class TuteePaymentScreen extends StatefulWidget {
  final ExtendedCourse course;
  final Enrollment enrollment;

  const TuteePaymentScreen(
      {Key key, @required this.course, @required this.enrollment})
      : super(key: key);
  @override
  _TuteePaymentScreenState createState() => _TuteePaymentScreenState();
}

class _TuteePaymentScreenState extends State<TuteePaymentScreen> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }

  //
  bool validateTotalAmount(double totalAmount) {
    if (totalAmount < 0) {
      return false;
    }
    return true;
  }

  //
  @override
  Widget build(BuildContext context) {
    //render ui
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(bottom: 100),
        child: Container(
          color: const Color(0xffC9CED4).withOpacity(0.35),
          child: Stack(
            children: [
              //for ui header color
              Container(
                height: 250,
                width: double.infinity,
                color: mainColor,
              ),

              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //payment method title
                    buildPaymentMethodTitle(),
                    //payment method
                    buildPaymentMethod(),
                    //transaction details title
                    _buildTransactionDetailTitle(),
                    //
                    Container(
                      width: 341,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [boxShadowStyle]),
                      child: Column(
                        children: [
                          //fee
                          Container(
                            width: 341,
                            height: 60,
                            alignment: Alignment.center,
                            child: ListTile(
                              leading: Text(
                                'Fee name',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: Text(
                                "Study fee payment",
                                style: textStyle,
                              ),
                            ),
                          ),
                          //Transfer to tutor
                          _buildTuteeTransferToTutor(),
                          //amount
                          _buildTuteeAmountToPay(),
                          PaymentItemDivider(),
                          //total amount
                          _buildTotalAmount(widget.course.studyFee)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _buildPayNowFAB(context, widget.course.studyFee),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Container _buildTotalAmount(double totalAmount) {
    return Container(
      width: 341,
      height: 60,
      alignment: Alignment.center,
      child: ListTile(
        leading: Text(
          'Total Amount',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Text(
          '\$$totalAmount',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: headerFontSize),
        ),
      ),
    );
  }

  Container _buildTuteeAmountToPay() {
    return Container(
      width: 341,
      height: 60,
      alignment: Alignment.center,
      child: ListTile(
        leading: Text(
          'Amount',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Text(
          '\$' + widget.course.studyFee.toString(),
          style: textStyle,
        ),
      ),
    );
  }

  Container _buildTuteeTransferToTutor() {
    return Container(
      width: 341,
      height: 60,
      alignment: Alignment.center,
      child: ListTile(
        leading: Text(
          'Transfer to tutor',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Text(
          widget.course.tutorName,
          style: textStyle,
        ),
      ),
    );
  }

  FloatingActionButton _buildPayNowFAB(
      BuildContext context, double totalAmount) {
    return FloatingActionButton.extended(
      onPressed: () async {
        //set enable onPress function for FAB
        payment_methods.checkOutTuteePayment(
            context, widget.course, totalAmount, widget.enrollment);
        //

        //disble FAB when fee is not loaded yet
      },
      isExtended: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      label: Container(
        margin: EdgeInsetsDirectional.only(
          bottom: 30,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: mainColor,
            boxShadow: [boxShadowStyle]),
        width: 341,
        height: 88,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 140,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff10D624),
              ),
              child: Text(
                'Check out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$$totalAmount',
                  style: TextStyle(
                    fontSize: headerFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Amount',
                  style: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTransactionDetailTitle() {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        bottom: 8,
        top: 20,
      ),
      child: Text(
        'Transaction Details',
        style: TextStyle(
          fontSize: titleFontSize,
          color: textWhiteColor,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: mainColor,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 15,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Payment',
        style: TextStyle(
          fontSize: headerFontSize,
          color: textWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

//common divider
class PaymentItemDivider extends StatelessWidget {
  const PaymentItemDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey[350],
      indent: 20,
      endIndent: 20,
      thickness: 1,
      height: 0,
    );
  }
}
