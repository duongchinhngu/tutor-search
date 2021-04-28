import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/firebase_functions.dart';
import 'package:tutor_search_system/models/tutor_update_profile.dart';
import 'package:tutor_search_system/repositories/notification_repository.dart';
import 'package:tutor_search_system/repositories/tutor_update_profile_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/update_tutor_profile/update_tutor_profile_variable.dart';
import 'package:tutor_search_system/screens/tutor_screens/update_tutor_profile/updated_pending_done_screen.dart';

class UpdateTutorProfileProcessingScreen extends StatefulWidget {
  final TutorUpdateProfile tutorUpdateProfile;

  const UpdateTutorProfileProcessingScreen(
      {Key key, @required this.tutorUpdateProfile})
      : super(key: key);
  @override
  _UpdateTutorProfileProcessingScreenState createState() =>
      _UpdateTutorProfileProcessingScreenState();
}

class _UpdateTutorProfileProcessingScreenState
    extends State<UpdateTutorProfileProcessingScreen> {
  Future<bool> completeTutorUpdateProfile(
      TutorUpdateProfile tutorUpdateProfile) async {
    tutorUpdateProfile.certificateImages =
        certificationImages.toString().replaceFirst(',', '').trim();
    print('thí í cerit: ' + tutorUpdateProfile.certificateImages);
    //
    if (avatarUpdate != null) {
      String imageUrl = await uploadFileOnFirebaseStorage(avatarUpdate);
      tutorUpdateProfile.avatarImageLink = imageUrl;
    }
    //
    if (socialIdImageFile != null) {
      String imageUrl = await uploadFileOnFirebaseStorage(socialIdImageFile);
      tutorUpdateProfile.socialIdUrl = imageUrl;
    }
    //
    await TutorUpdateProfileRepository()
        .deleteTutorUpdateProfilebyId(tutorUpdateProfile.id);
    //
    await TutorUpdateProfileRepository().postUpdateProfile(tutorUpdateProfile);

    await NotificationRepository().postAllManagerNotification(
        'Update Profile', 'Update profile request!');
    //
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completeTutorUpdateProfile(widget.tutorUpdateProfile),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => CompletedRequestUpdateScreen()),
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
