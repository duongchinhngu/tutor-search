import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/screens/tutor_screens/tutor_register_screens/register_elements.dart';
import 'tutee_register_processing_screen.dart';
import 'tutee_register_variables.dart';

//
TextEditingController nameController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController birthdayController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController addressController = TextEditingController();

//validator for all input field
GlobalKey<FormState> formkey = GlobalKey<FormState>();

//image for choosing from phone storage
File avatarImage;
//

//
class TuteeRegisterScreen extends StatefulWidget {
  @override
  _TuteeRegisterScreenState createState() => _TuteeRegisterScreenState();
}

class _TuteeRegisterScreenState extends State<TuteeRegisterScreen> {
  //select image from storage
  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      avatarImage = image;
    });
  }

  //select image from taking picture
  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      avatarImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            //1st stack
            Container(
              width: double.infinity,
              height: 610,
              margin: EdgeInsets.only(
                left: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[300].withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                  bottomLeft: Radius.circular(00),
                ),
              ),
            ),
            //2st stack
            Container(
              width: double.infinity,
              height: 600,
              margin: EdgeInsets.only(
                left: 25,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                  bottomLeft: Radius.circular(00),
                ),
              ),
            ),
            //3nd stack
            AspectRatio(
              aspectRatio: 2 / 3.85,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    //avatar selector
                    buildAvatarSelector(),
                    //cotainer all input fields
                    InputBody(),
                  ],
                ),
              ),
            ),
            //back button
            buildBackButton(context),
          ],
        ),
      ),
    );
  }

  AspectRatio buildBackButton(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3.85,
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsetsDirectional.only(
          top: 20,
          start: 10,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            //show confirm delete inputs of registration tutor
            showDialog(
              context: context,
              builder: (context) => buildDefaultDialog(
                context,
                'Your inputs would be lost!',
                'Do you want to continue?',
                [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      //reset to default value
                      resetRegisterTutee();
                      //2 times pop to back to home screen
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Continue'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

//image selector
  InkWell buildAvatarSelector() {
    return InkWell(
      onTap: () => getImageFromGallery(),
      child: Container(
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //circle blue box behind the circle avatar
            Container(
              height: 175,
              width: 175,
              decoration: BoxDecoration(
                color: Colors.blue[500].withOpacity(0.35),
                shape: BoxShape.circle,
              ),
            ),
            //avartar
            CircleAvatar(
              foregroundColor: Colors.green,
              radius: 80,
              backgroundImage: avatarImage != null
                  ? FileImage(
                      avatarImage,
                    )
                  : NetworkImage(''),
            ),
            //edit avartar icon
            Positioned(
              bottom: 40,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[500].withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: textGreyColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//contain all input fields
class InputBody extends StatefulWidget {
  const InputBody({
    Key key,
  }) : super(key: key);

  @override
  _InputBodyState createState() => _InputBodyState();
}

class _InputBodyState extends State<InputBody> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Container(
        // color: Colors.red,
        width: double.infinity,
        padding: EdgeInsets.only(
          right: 20,
        ),
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //title
            Text(
              'Registration as Tutee',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            //fullname text field
            buildInputField(
              'Fullname',
              'What should we call you',
              TextInputType.name,
              MultiValidator([
                RequiredValidator(errorText: 'Fullname is required!'),
              ]),
              nameController,
            ),
            //gender text field and birthday text field bottom up
            Container(
              width: 260,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // gender text field
                  OnPressableInputField(
                    title: 'Gender',
                    controller: genderController,
                    bottomUpList: [GENDER_MALE, GENDER_FEMALE],
                    widthLength: 100,
                  ),
                  //birthday text field bottom up
                  OnPressableInputField(
                    title: 'Birthday',
                    controller: birthdayController,
                    widthLength: 130,
                  ),
                ],
              ),
            ),
            //email text field
            buildInputField(
              'Email',
              'your email address',
              TextInputType.emailAddress,
              MultiValidator([
                RequiredValidator(errorText: 'Email is required!'),
                EmailValidator(errorText: 'Email format is not correct!')
              ]),
              emailController,
            ),
            //phone text field
            buildInputField(
                'Phone',
                'Your number phone',
                TextInputType.phone,
                MultiValidator([
                  RequiredValidator(errorText: 'Phone is required!'),
                ]),
                phoneController),

            //Address text field
            buildInputField(
              'Address',
              'Where are you living',
              TextInputType.streetAddress,
              MultiValidator([
                RequiredValidator(errorText: 'Address is required!'),
              ]),
              addressController,
            ),
            //
            buildCreateButton(),
          ],
        ),
      ),
    );
  }

  InkWell buildCreateButton() {
    return InkWell(
      onTap: () async {
        if (formkey.currentState.validate()) {
          formkey.currentState.save();
          //chech whether or not this email exist in Account table in DB
          await AccountRepository()
              .isEmailExist(http.Client(), emailController.text)
              .then((isExist) {
            if (isExist == 'false') {
              //navigate to processing screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                return Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TuteeRegisterProccessingScreen(
                      tutee: registerTutee,
                    ),
                  ),
                );
              });
            } else {
              //if this email is used to register already
              showDialog(
                context: context,
                builder: (context) => buildAlertDialog(
                  context,
                  'This email is already registered!',
                ),
              );
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: 150,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffA80C0C),
        ),
        child: Text(
          'Create',
          style: TextStyle(
            fontSize: titleFontSize,
            color: textWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
