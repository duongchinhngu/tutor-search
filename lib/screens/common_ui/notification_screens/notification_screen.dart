import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/notification_cubit.dart';
import 'package:tutor_search_system/repositories/notification_repository.dart';
import 'package:tutor_search_system/states/notification_state.dart';

import '../error_screen.dart';
import '../no_data_screen.dart';
import '../waiting_indicator.dart';

class NotificationScreen extends StatefulWidget {
  final String receiverEmail;

  const NotificationScreen({Key key, @required this.receiverEmail})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      appBar: AppBar(
        backgroundColor: mainColor,
        // centerTitle: true,
        title: Text(
          'Notification',
        ),
      ),
      body: BlocProvider(
        create: (BuildContext context) =>
            NotificationCubit(NotificationRepository()),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            //
            final notiCubit = context.watch<NotificationCubit>();
            notiCubit.getNotificationByEmail(widget.receiverEmail);
            //
            if (state is NotificationErrorState) {
              return ErrorScreen();
              // return Text(state.errorMessage);
            } else if (state is InitialNotificationState) {
              return buildLoadingIndicator();
            } else if (state is NotificationNoDataState) {
              return NoDataScreen();
            } else if (state is NotificationListLoadedState) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.separated(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) =>
                      buildNotificationCard(state, index),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    indent: 20,
                    endIndent: 10,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  ListTile buildNotificationCard(NotificationListLoadedState state, int index) {
    return ListTile(
      leading: Container(
        height: 70,
        width: 70,
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://i.pinimg.com/originals/38/2a/fd/382afdef2846d1ff6e30d5185b0e207b.png'),
        ),
      ),
      title: Text(
        state.notifications[index].message,
        style: TextStyle(
          fontSize: titleFontSize,
          color: textGreyColor,
        ),
      ),
      subtitle: Text(
        state.notifications[index].createdDate.replaceFirst('T', ' '),
        style: TextStyle(fontSize: textFontSize, color: Colors.grey[500]),
      ),
    );
  }
}
