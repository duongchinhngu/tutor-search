import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_register_screens/tutee_register_screen.dart';

//selected birthday
DateTime selectedBirthday;
//
//tutee object
// final ssss = Tutee.constructor(id, fullname, gender, birthday, email, phone, address, status, roleId, description, avatarImageLink)
Tutee registerTutee = Tutee.constructor(
  0,
  // fullname
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
  'Active',
  //roleId
  4,
  //description
  '',
  //image link
  '',
);

//clear all text controllers of register tutee
void resetTextController() {
  nameController.clear();
  genderController.clear();
  birthdayController.clear();
  emailController.clear();
  phoneController.clear();
  addressController.clear();
}

//reset ALL selected field to register Tutee:
// imageLink, selectedBirthday, registerTutee class, textcontrollers,...
resetRegisterTutee() {
  //reset selectedBirthday;
  selectedBirthday = null;
  //reset all textControllers
  resetTextController();
  //
  registerTutee = Tutee.constructor(
    0,
    // fullname
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
    'Active',
    //roleId
    4,
    //description
    '',
    //image link
    '',
  );
}
