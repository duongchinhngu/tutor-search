//alert dialog when there is an empty required field
import 'package:flutter/material.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';

//common alert dialog
AlertDialog buildAlertDialog(BuildContext context, String label) {
  return AlertDialog(
    title: Container(
      width: double.infinity,
      // height: 70,
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/sad.png',
        height: 70,
        width: 170,
      ),
    ),
    content: Container(
      width: double.infinity,
      height: 20,
      alignment: Alignment.center,
      child: Text(
        // 'There is an empty required field!',
        label,
        style: textStyle,
      ),
    ),
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: mainColor, // background
          onPrimary: textWhiteColor, // foreground
          elevation: 1.0,
        ),
        child: Center(
          // width: double.infinity

          child: Text('Ok'),
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
      )
    ],
  );
}

//common dialog
AlertDialog buildDefaultDialog(
    BuildContext context, String title, String content, List<Widget> actions) {
  return AlertDialog(
    backgroundColor: backgroundColor.withOpacity(1),
    elevation: 0.0,
    title: Text(
      title,
      style: TextStyle(
        color: textGreyColor,
      ),
    ),
    content: Text(
      content,
      style: TextStyle(
        color: textGreyColor,
      ),
    ),
    actions: actions,
  );
}

//confirm dialog default
Future showDefaultConfirmDialog(BuildContext context, String title, String subtitle, Function continueFunction) {
  return showDialog(
    context: context,
    builder: (context) => buildDefaultDialog(
      context,
      title,
      subtitle,
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: continueFunction,
              child: Text('Ok'),
            )
          ],
        ),
      ],
    ),
  );
}


//sign out function common
Future showLogoutConfirmDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => buildDefaultDialog(
      context,
      'Are you sure to continue?',
      'Click cancel to be out',
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final loginRepository = LoginRepository();
                  //sign out
                  await loginRepository.handleSignOut(context);
                } catch (error) {
                  print('You are not allowed! $error');
                }
              },
              child: Text('Sign out'),
            )
          ],
        ),
      ],
    ),
  );
}
