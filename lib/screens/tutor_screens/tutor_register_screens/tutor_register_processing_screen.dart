import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/functions/firebase_functions.dart';
import 'package:tutor_search_system/models/account.dart';
import 'package:tutor_search_system/models/tutor.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/repositories/image_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/error_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_register_screens/tutor_register_variables.dart';
import 'tutor_register_screen.dart' as tutor_screen;
import 'package:tutor_search_system/models/image.dart' as image;
import 'tutor_register_successfully.dart';

//processing REgister tutor
class TutorRegisterProccessingScreen extends StatefulWidget {
  final Tutor tutor;

  const TutorRegisterProccessingScreen({Key key, this.tutor}) : super(key: key);
  @override
  _TutorRegisterProccessingScreenState createState() =>
      _TutorRegisterProccessingScreenState();
}

class _TutorRegisterProccessingScreenState
    extends State<TutorRegisterProccessingScreen> {
  //
  final tutorRepository = TutorRepository();
  //
  final imageRepository = ImageRepository();
  //
  Future<bool> registerTutor(Tutor tutor) async {
    tutor.fullname = tutor_screen.nameController.text;
    tutor.gender = tutor_screen.genderController.text;
    tutor.birthday = tutor_screen.birthdayController.text;
    tutor.email = tutor_screen.emailController.text;
    tutor.phone = tutor_screen.phoneController.text;
    tutor.address = tutor_screen.addressController.text;
    tutor.educationLevel = tutor_screen.educationLevelController.text;
    tutor.school = tutor_screen.schoolController.text;

    //init account obj
    final account =
        Account.constructor(0, tutor.email, tutor.roleId, '', 'Active');
    //post Account
    await AccountRepository().postAcount(account);
    //after post image on Firebase; get link and set to tutor
    if (avatarImage != null) {
      var imageUrl = await uploadFileOnFirebaseStorage(avatarImage);
      tutor.avatarImageLink = imageUrl;
    }
    if (socialIdImage != null) {
      var imageUrl = await uploadFileOnFirebaseStorage(socialIdImage);
      tutor.socialIdUrl = imageUrl;
    }
    //post tutor
    await tutorRepository.postTutor(tutor);
    //post Image to DB
    if (certificationImages.length > 1) {
      //remove ADD image icon File in default certification image list
      certificationImages.remove(certificationImages.first);
      //
      for (var certitfication in certificationImages) {
        var imageUrl = await uploadFileOnFirebaseStorage(certitfication);
        // post certification url to Image table in DB
        imageRepository.postImage(
          new image.Image.constructor(
              0, imageUrl, 'certification', tutor.email),
        );
      }
    }
    return Future.value(true);
  }

  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: registerTutor(widget.tutor),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          if (snapshot.hasData == true) {
            //reset to defaul value of tuee
            resetRegisterTutor();
            //
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
