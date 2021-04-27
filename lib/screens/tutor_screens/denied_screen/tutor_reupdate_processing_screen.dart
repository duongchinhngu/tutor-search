import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/firebase_functions.dart';
import 'package:tutor_search_system/models/tutor.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_register_screens/tutor_register_successfully.dart';
import 'package:tutor_search_system/screens/tutor_screens/update_tutor_profile/update_tutor_profile_variable.dart';

class ReUpdateTutorProfileProcessingScreen extends StatefulWidget {
  final Tutor reupdateTutor;

  const ReUpdateTutorProfileProcessingScreen(
      {Key key, @required this.reupdateTutor})
      : super(key: key);
  @override
  _ReUpdateTutorProfileProcessingScreenState createState() =>
      _ReUpdateTutorProfileProcessingScreenState();
}

class _ReUpdateTutorProfileProcessingScreenState
    extends State<ReUpdateTutorProfileProcessingScreen> {
  Future<bool> completeTutorUpdateProfile(Tutor reupdateTutor) async {
    //
    if (avatarUpdate != null) {
      String imageUrl = await uploadFileOnFirebaseStorage(avatarUpdate);
      reupdateTutor.avatarImageLink = imageUrl;
      print('ti sí image link: ' + imageUrl);
    }
    //
    await TutorRepository().putTutor(reupdateTutor);
    //
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completeTutorUpdateProfile(widget.reupdateTutor),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => TutorRegisterSuccessfullyScreen()),
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
