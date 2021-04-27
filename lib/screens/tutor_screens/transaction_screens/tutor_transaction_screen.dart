import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/tutor_transaction_cubit.dart';
import 'package:tutor_search_system/repositories/tutor_transaction_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutor_screens/transaction_screens/tutor_transaction_detail_screen.dart';
import 'package:tutor_search_system/states/tutor_transaction_state.dart';

class TutorTransactionScreen extends StatefulWidget {
  @override
  _TutorTransactionScreenState createState() => _TutorTransactionScreenState();
}

class _TutorTransactionScreenState extends State<TutorTransactionScreen> {
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
      // appBar: GradientAppBar(
      //   title: Text('Flutter Gradient Example'),
      //   gradient: LinearGradient(
      //     colors: [
      //       Colors.cyan,
      //       Colors.indigo,
      //     ],
      //   ),
      // ),
      // // appBar: GradientAppBar(
      // //   gradient: LinearGradient(
      // //       begin: Alignment.topCenter,
      // //       end: Alignment.bottomCenter,
      // //       colors: [
      // //         mainColor,
      // //         backgroundColor,
      // //       ]),
      // //   leading: IconButton(
      // //     icon: Icon(
      // //       Icons.arrow_back_ios,
      // //       color: backgroundColor,
      // //       size: 15,
      // //     ),
      // //     onPressed: () => Navigator.pop(context),
      // //   ),
      // //   centerTitle: true,
      // //   title: Text(
      // //     'Transactions',
      // //   ),
      // //   actions: [Icon(Icons.sort)],
      // // ),
      appBar: AppBar(
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
      ),
      body: BlocProvider(
        create: (context) =>
            TutorTransactionCubit(TutorTransactionRepository()),
        child: BlocBuilder<TutorTransactionCubit, TutorTransactionState>(
            builder: (context, state) {
          //
          final tutorTransactionCubit = context.watch<TutorTransactionCubit>();
          tutorTransactionCubit
              .getTutorTransactionByTutorId(authorizedTutor.id);
          //
          if (state is TutorTransactionErrorState) {
            return ErrorScreen();
            // return Text(state.errorMessage);
          } else if (state is InitialTutorTransactionState) {
            return buildLoadingIndicator();
          } else if (state is TutorTransactionNoDataState) {
            return NoDataScreen();
          } else if (state is TutorTransactionListLoadedState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.tutorTransactions.length,
                itemBuilder: (context, index) {
                  return buildTutorTransactionCard(state, index);
                },
              ),
            );
          }
        }),
      ),
      //
    );
  }

  Widget buildTutorTransactionCard(
      TutorTransactionListLoadedState state, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TutorTransactonDetailScreen(
              tuteeTransaction: state.tutorTransactions[index],
            ),
          ),
        );
      },
      child: Container(
        height: 50,
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
                    state.tutorTransactions[index].feeName,
                    style: TextStyle(
                        fontSize: titleFontSize,
                        color: Color(0xff04046D),
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        state.tutorTransactions[index].dateTime
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
                        state.tutorTransactions[index].status,
                        style: textStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
            //
            Text(
              '\$' + state.tutorTransactions[index].totalAmount.toString(),
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
