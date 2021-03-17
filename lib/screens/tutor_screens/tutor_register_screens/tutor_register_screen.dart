import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'register_elements.dart';
import 'tutor_register_processing_screen.dart';
import 'tutor_register_variables.dart';
import 'package:http/http.dart' as http;

//
TextEditingController nameController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController birthdayController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController educationLevelController = TextEditingController();
TextEditingController schoolController = TextEditingController();

//validator for all input field
GlobalKey<FormState> formkey = GlobalKey<FormState>();

class TutorRegisterScreen extends StatefulWidget {
  @override
  _TutorRegisterScreenState createState() => _TutorRegisterScreenState();
}

class _TutorRegisterScreenState extends State<TutorRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: buildFloatingActionButton(context),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: mainColor,
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsetsDirectional.only(start: 25, top: 85),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300.withOpacity(.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(275),
                      bottomLeft: Radius.circular(00),
                    ),
                  ),
                  child: Container(
                    // height: 500,
                    padding: EdgeInsets.only(
                      bottom: 40,
                    ),
                    width: double.infinity,
                    margin: EdgeInsetsDirectional.only(start: 5, top: 15),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(275),
                        bottomLeft: Radius.circular(00),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: 140),
                      child: Column(
                        children: [
                          //cotainer all input fields
                          InputBody(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //avatar selector
              buildAvatarSelector(),
            ],
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: Colors.transparent,
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
                  resetRegisterTutor();
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
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    );
  }

  //image selector
  InkWell buildAvatarSelector() {
    return InkWell(
      onTap: () async {
        // ignore: deprecated_member_use
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          avatarImage = image;
        });
      },
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
              'Registration as Tutor',
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
                  OnPressableTutorInputField(
                    title: 'Gender',
                    controller: genderController,
                    bottomUpList: [GENDER_MALE, GENDER_FEMALE],
                    widthLength: 100,
                  ),
                  //birthday text field bottom up
                  OnPressableTutorInputField(
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
            //gender text field and birthday text field bottom up
            OnPressableTutorInputField(
              title: 'Education Level',
              controller: educationLevelController,
              bottomUpList: ['Colledge', 'University', 'Student', 'Teacher'],
              widthLength: 260,
            ),
            //School text field
            buildInputField(
              'School',
              'Where you graduated from',
              TextInputType.text,
              MultiValidator([
                RequiredValidator(errorText: 'School is required!'),
              ]),
              schoolController,
            ),
            //social id image selector
            Container(
              height: 250,
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Social Id Image',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: titleFontSize,
                    ),
                  ),
                  //social id image
                  Container(
                    height: 200,
                    width: 260,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: mainColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue[50].withOpacity(.4),
                    ),
                    child: (socialIdImage != null)
                        ? InkWell(
                            onTap: () async {
                              //select Photo from camera
                              var img = await getImageFromCamera();
                              if (img != null) {
                                setState(() {
                                  socialIdImage = img;
                                });
                              }
                            },
                            child: Image.file(
                              socialIdImage,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              //select Photo from camera
                              var img = await getImageFromCamera();
                              if (img != null) {
                                setState(() {
                                  socialIdImage = img;
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add_a_photo,
                                color: mainColor.withOpacity(0.7),
                                size: 50,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            //certification images
            Container(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      'Certification Image(s)',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: titleFontSize,
                      ),
                    ),
                  ),
                  Container(
                    width: 260,
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      runSpacing: 10,
                      spacing: 10,
                      children: List.generate(
                        certificationImages.length,
                        (index) {
                          //element is the first image; it is for take photo by camera
                          if (index == 0) {
                            return InkWell(
                              onTap: () async {
                                //select Photo from camera
                                var img = await getImageFromCamera();
                                if (img != null) {
                                  setState(() {
                                    certificationImages.add(img);
                                  });
                                }
                              },
                              child: Container(
                                height: 125,
                                width: 125,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: mainColor.withOpacity(0.7),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50].withOpacity(.4),
                                  border: Border.all(
                                    width: 1.0,
                                    color: mainColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            //view photo in fullscreen
                            return Container(
                              height: 125,
                              width: 125,
                              child: PopupMenuButton(
                                child: Image.file(
                                  certificationImages[index],
                                  fit: BoxFit.cover,
                                ),
                                itemBuilder: (context) {
                                  return <PopupMenuItem>[
                                    PopupMenuItem(
                                      child: TextButton(
                                        child: Text('Detail'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenImage(
                                                imageWidget: Image.file(
                                                  certificationImages[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: TextButton(
                                        child: Text(
                                          'Remove',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.red.withOpacity(.8),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            certificationImages.removeAt(index);
                                          });
                                        },
                                      ),
                                    )
                                  ];
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            buildCreateButton(context),
          ],
        ),
      ),
    );
  }

//image selector
  InkWell buildAvatarSelector() {
    return InkWell(
      onTap: () async {
        // ignore: deprecated_member_use
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          avatarImage = image;
        });
      },
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

//create button
InkWell buildCreateButton(BuildContext context) {
  return InkWell(
    onTap: () async {
      if (formkey.currentState.validate()) {
        formkey.currentState.save();
        //
        if (socialIdImage != null) {
          //chech whether or not this email exist in Account table in DB
          await AccountRepository()
              .isEmailExist(http.Client(), emailController.text)
              .then((isExist) {
            if (isExist == 'false') {
              //navigate to processing screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                return Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TutorRegisterProccessingScreen(
                      tutor: registerTutor,
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
        } else {
          return buildAlertDialog(context, 'Social ID Image is required!');
        }
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
