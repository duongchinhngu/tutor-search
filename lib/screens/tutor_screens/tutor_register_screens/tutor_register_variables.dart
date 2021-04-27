import 'dart:io';
import 'package:tutor_search_system/models/tutor.dart';
import 'tutor_register_screen.dart';

//selected birthday (datetime type)
DateTime selectedTutorBirthday;
//

//image for choosing from phone storage
File avatarImage;
//socialId image
File socialIdImage;
//list of certificationImg
List<File> certificationImages = [
  File(
      'assets\images\education-concept-vector-illustration-in-flat-style-online-education-school-university-creative-ideas.jpg')
];

//tutor object
Tutor registerTutor = Tutor.constructor(
  0,
  //fullname
  '',
  //gender
  '',
  //birthday
  '',
  //email
  '',
  //phone
  '',
  //address
  '',
  //status
  'Pending',
  //roleId
  3,
  //desription
  '',
  //avatar imale link
  '',
  //edu level
  '',
  //school
  '',
  //pointsave
  0,
  //membershipId
  6,
  //social id url
  '',
  //certification url
);

//clear all text controllers of register  tutor
void resetTextController() {
  nameController.clear();
  genderController.clear();
  birthdayController.clear();
  emailController.clear();
  phoneController.clear();
  addressController.clear();
  educationLevelController.clear();
  schoolController.clear();
  descriptionController.clear();
  avatarImage = null;
//socialId image
  socialIdImage = null;
//list of certificationImg
  certificationImages = [
    File(
        'assets\images\education-concept-vector-illustration-in-flat-style-online-education-school-university-creative-ideas.jpg')
  ];
}

//reset ALL selected field to register  tutor:
// imageLink, selectedBirthday, register tutor class, textcontrollers,...
resetRegisterTutor() {
  //reset selectedBirthday;
  selectedTutorBirthday = null;
  //reset all textControllers
  resetTextController();
  //
  registerTutor = Tutor.constructor(
    0,
    //fullname
    '',
    //gender
    '',
    //birthday
    '',
    //email
    '',
    //phone
    '',
    //address
    '',
    //status
    'Pending',
    //roleId
    3,
    //desription
    '',
    //avatar imale link
    '',
    //edu level
    '',
    //school
    '',
    //pointsave
    0,
    //membershipId
    1,
    //social id url
    '',
    //certification url
  );
}
