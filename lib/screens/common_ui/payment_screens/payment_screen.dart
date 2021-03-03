import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/fee_cubit.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'payment_methods.dart' as payment_methods;
import 'package:tutor_search_system/repositories/fee_repository.dart';
import 'package:tutor_search_system/states/fee_state.dart';

//use point controller text
TextEditingController usePointController = TextEditingController();

//
class PaymentScreen extends StatefulWidget {
  final Course course;

  const PaymentScreen({Key key, @required this.course}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
    return BlocProvider(
      create: (context) => FeeCubit(FeeRepository()),
      child: BlocBuilder<FeeCubit, FeeState>(builder: (context, state) {
        //init feeId
        int feeId = 0;
        //set proper feeId
        //tutor payment has feeId = 2 (create course fee); tutee has feeId = 1 (joining course fee)
        if (globals.authorizedTutee != null) {
          feeId = 1;
        } else if (globals.authorizedTutor != null) {
          feeId = 2;
        }
        //
        //total amount
        double totalAmount = 0;
        //
        final feeCubit = context.watch<FeeCubit>();
        feeCubit.getFeeByFeeId(feeId);
        //
        //set total amount
        if (state is FeeLoadedState) {
          if (globals.authorizedTutee != null) {
            totalAmount += state.fee.price + widget.course.studyFee;
          } else if (globals.authorizedTutor != null) {
            totalAmount = totalAmount +
                state.fee.price -
                int.parse(usePointController.text != ''
                    ? usePointController.text
                    : '0');
          }
        }
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
                        _buildPaymentMethodTitle(),
                        //payment method
                        _buildPaymentMethod(),
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
                                    state is FeeLoadedState
                                        ? state.fee.name
                                        : 'Loading..',
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              //Transfer to tutor
                              //tutee only
                              Visibility(
                                visible: globals.authorizedTutee != null,
                                child: _buildTuteeTransferToTutor(),
                              ),
                              //amount
                              //tutee only
                              Visibility(
                                visible: globals.authorizedTutee != null,
                                child: _buildTuteeAmountToPay(),
                              ),
                              PaymentItemDivider(),
                              //fee
                              Container(
                                width: 341,
                                height: 60,
                                alignment: Alignment.center,
                                child: ListTile(
                                  leading: Text(
                                    'Fee',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                  trailing: Text(
                                    state is FeeLoadedState
                                        ? '\$' + state.fee.price.toString()
                                        : 'Loading..',
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              //
                              PaymentItemDivider(),
                              //use point of tutor
                              Visibility(
                                visible: globals.authorizedTutor != null,
                                child: Container(
                                  width: 341,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    leading: Text(
                                      'Use point(s)',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    trailing: Container(
                                      width: 140,
                                      height: 40,
                                      child: TextFormField(
                                        controller: usePointController,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                          signed: false,
                                          decimal: true,
                                        ),
                                        textAlign: TextAlign.start,
                                        // if user has 0 point => set enable is true
                                        enabled:
                                            globals.authorizedTutor.points != 0,
                                        //
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (usePoint) {
                                          setState(() {
                                            totalAmount -= int.parse(usePoint);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          fillColor: Color(0xffF9F2F2),
                                          filled: true,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0),
                                          ),
                                          hintText: globals
                                                  .authorizedTutor.points
                                                  .toString() +
                                              ' point(s) available',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              PaymentItemDivider(),
                              //total amount
                              _buildTotalAmount(totalAmount),
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
          floatingActionButton: _buildPayNowFAB(state, context, totalAmount),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      }),
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
          widget.course.createdBy.toString(),
          style: textStyle,
        ),
      ),
    );
  }

  FloatingActionButton _buildPayNowFAB(
      FeeState state, BuildContext context, double totalAmount) {
    return FloatingActionButton.extended(
      onPressed: () async {
        //set enable onPress function for FAB
        if (state is FeeLoadedState) {
          if (globals.authorizedTutee != null) {
            //post TuteeTransaction
            payment_methods.completeTuteeTransaction(
                context, widget.course, totalAmount);
          } else if (globals.authorizedTutor != null) {
            //validate total amoount
            if (validateTotalAmount(totalAmount)) {
              //post Tutor Transaction
              payment_methods.completeTutorTransaction(
                  context,
                  widget.course,
                  totalAmount,
                  int.parse(usePointController.toString()),
                  state.fee);
            } else {
              //show dialog alert
              showDialog(
                context: context,
                builder: (context) => buildAlertDialog(
                    context, 'Total amount must be greater than 0!'),
              );
            }
          }
        }
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
                'Pay Now',
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

  Container _buildPaymentMethod() {
    return Container(
      width: 341,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.35)),
      child: ListTile(
        leading: Image.asset(
          'assets/images/MoMo_Logo.png',
          height: 40,
        ),
        title: Text(
          'MoMo wallet',
          style: TextStyle(
            color: textWhiteColor,
            fontSize: titleFontSize,
          ),
        ),
      ),
    );
  }

  Container _buildPaymentMethodTitle() {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        bottom: 8,
      ),
      child: Text(
        'Payment Method',
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
