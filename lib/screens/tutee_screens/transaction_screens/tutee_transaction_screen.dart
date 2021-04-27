import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/tutee_transaction_cubit.dart';
import 'package:tutor_search_system/repositories/tutee_transaction_repository.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/transaction_screens/tutee_transaction_detail_screen.dart';
import 'package:tutor_search_system/states/tutee_transaction_state.dart';

class TuteeTransactionScreen extends StatefulWidget {
  @override
  _TuteeTransactionScreenState createState() => _TuteeTransactionScreenState();
}

class _TuteeTransactionScreenState extends State<TuteeTransactionScreen> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      body: BlocProvider(
        create: (context) =>
            TuteeTransactionCubit(TuteeTransactionRepository()),
        child: BlocBuilder<TuteeTransactionCubit, TuteeTransactionState>(
            builder: (context, state) {
          //
          final tuteeTransactionCubit = context.watch<TuteeTransactionCubit>();
          tuteeTransactionCubit
              .getTuteeTransactionByTuteeId(authorizedTutee.id);
          //
          if (state is TuteeTransactionErrorState) {
            return Text(state.errorMessage);
          } else if (state is InitialTuteeTransactionState) {
            return buildLoadingIndicator();
          } else if (state is TuteeTransactionNoDataState) {
            return NoDataScreen();
          } else if (state is TuteeTransactionListLoadedState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.tuteeTransactions.length,
                itemBuilder: (context, index) {
                  return buildTuteeTransactionCard(state, index);
                },
              ),
            );
          }
        }),
      ),
      //
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mainColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: backgroundColor,
          size: 15,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        'Transactions',
      ),
      // actions: [Icon(Icons.sort)],
    );
  }

  Widget buildTuteeTransactionCard(
      TuteeTransactionListLoadedState state, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => TuteeTransactonDetailScreen(
                    tuteeTransaction: state.tuteeTransactions[index],
                  )),
        );
      },
      child: Container(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //
            Container(
                child: Icon(
              Icons.payments,
              size: 30,
              color: Colors.orange,
            )),
            //
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    state.tuteeTransactions[index].name,
                    style: TextStyle(
                        fontSize: titleFontSize,
                        color: Color(0xff04046D),
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        'for course ',
                        style: textStyle,
                      ),
                      Text(state.tuteeTransactions[index].courseName),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        state.tuteeTransactions[index].dateTime
                            .substring(0, 10),
                        style: textStyle,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        state.tuteeTransactions[index].status,
                        style: textStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
            //
            Text(
              '\$' + state.tuteeTransactions[index].totalAmount.toString(),
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
