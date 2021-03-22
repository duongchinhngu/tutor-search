import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/firebase_functions.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_profile/tutee_profile_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_profile/update_tutee_profile_screen.dart'
    as tutee_update_screen;

class TuteeUpdateProfileProcessingScreen extends StatefulWidget {
  final Tutee tutee;

  const TuteeUpdateProfileProcessingScreen({Key key, this.tutee})
      : super(key: key);
  @override
  _TuteeUpdateProfileProcessingScreenState createState() =>
      _TuteeUpdateProfileProcessingScreenState();
}

class _TuteeUpdateProfileProcessingScreenState
    extends State<TuteeUpdateProfileProcessingScreen> {
  final tuteeRepository = TuteeRepository();

  Future<bool> updateTuteeProfile(Tutee tutee) async {
    tutee.fullname = tutee_update_screen.fullnameController.text;
    tutee.gender = tutee_update_screen.genderupdateController.text;
    tutee.phone = tutee_update_screen.phoneUpdateController.text;
    tutee.address = tutee_update_screen.addressUpdateController.text;
    tutee.birthday = tutee_update_screen.birthdayUpdateController.text;

    if (tutee_update_screen.avatartUpdate != null) {
      var imageUrl =
          await uploadFileOnFirebaseStorage(tutee_update_screen.avatartUpdate);
      tutee.avatarImageLink = imageUrl;
    }

    await tuteeRepository.putTuteeUpdate(tutee, tutee.id);

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateTuteeProfile(widget.tutee),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            //reset to defaul value of tuee
            //
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => TuteeProfileManagement(
                          snackBarIcon: Icons.check_circle_outline_outlined,
                          snackBarTitle: 'Update Profile Successfully',
                          snackBarContent: 'Continue to enjoy app!',
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
