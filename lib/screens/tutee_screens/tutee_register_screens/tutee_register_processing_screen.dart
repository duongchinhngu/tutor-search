import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/firebase_functions.dart';
import 'package:tutor_search_system/models/account.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/common_ui/login_screen.dart';
import 'tutee_register_screen.dart' as tutee_screen;
import 'tutee_register_variables.dart';

////processing REgister tutee
class TuteeRegisterProccessingScreen extends StatefulWidget {
  final Tutee tutee;

  const TuteeRegisterProccessingScreen({Key key, this.tutee}) : super(key: key);
  @override
  _TuteeRegisterProccessingScreenState createState() =>
      _TuteeRegisterProccessingScreenState();
}

class _TuteeRegisterProccessingScreenState
    extends State<TuteeRegisterProccessingScreen> {
  //
  final tuteeRepository = TuteeRepository();
  //
  final accountRepository = AccountRepository();

  Future<bool> registerTutee(Tutee tutee) async {
    //
    tutee.fullname = tutee_screen.nameController.text;
    tutee.gender = tutee_screen.genderController.text;
    tutee.birthday = tutee_screen.birthdayController.text;
    tutee.email = tutee_screen.emailController.text;
    tutee.phone = tutee_screen.phoneController.text;
    tutee.address = tutee_screen.addressController.text;
    //need to refactor
    //after post image on Firebase; get link and set to tutee
    if (tutee_screen.avatarImage != null) {
      var imageUrl =
          await uploadFileOnFirebaseStorage(tutee_screen.avatarImage);
      tutee.avatarImageLink = imageUrl;
    }
    //init account obj
    final account =
        Account.constructor(0, tutee.email, tutee.roleId, '', 'Active');
    account.showAttribute();
    //post Account
    await accountRepository.postAcount(account);
    tutee.showAttributes();
    //post course
    await tuteeRepository.postTutee(tutee);

    return Future.value(true);
  }

  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: registerTutee(widget.tutee),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            //reset to defaul value of tuee
            resetRegisterTutee();
            //
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          snackBarIcon: Icons.check_circle_outline_outlined,
                          snackBarTitle: 'Registered successfully',
                          snackBarContent: 'Login to explore now!',
                          snackBarThemeColor: Colors.green.shade600,
                        )),
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