import 'package:intl/intl.dart';
import 'package:tutor_search_system/models/tutee.dart';
// import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/models/tutor.dart';

//---------------------user authentication variables------------------------------------------------------
// tutee id for all page can access; this will be reseted when login succeed

Tutee authorizedTutee ;
// = Tutee(
//   id: 17,
//   status: 'Active',
//   fullname: 'Nguyen Trung Huy',
//   gender: 'Male',
//   birthday: '30-12-2998',
//   email: 'huyntse63450@fpt.edu.vn',
//   phone: '0393769476',
//   avatarImageLink:
//       'https://firebasestorage.googleapis.com/v0/b/tutor-search-project.appspot.com/o/successful-college-student-lg.png?alt=media&token=d66ef0a5-8c8c-4f05-934a-b96f0585c264',
//   address: 'dai hoc bach khoa ho chi minh',
//   roleId: 4,
// );

//
//tutor id for all page can access;
//  this will be reseted when tutor login succeeded
//authorized tutor
Tutor authorizedTutor;

//membershipname of signedin tutor
String membershipName = '';
//

//-------------------------------------orther common variables----------------------------------------------
//default datetime
const defaultDatetime = '1990-01-01';
//default 'No select' variable
const DEFAULT_NO_SELECT = 'No select';
//date formatter
final dateFormatter = new DateFormat('yyyy-MM-dd');
//time formatter
final timeFormatter = new DateFormat('HH:mm');
//--------------------------------------------------------------------------------------------------------
const feeRangeContent1 = 'Below \$25';
const feeRangeContent2 = '\$25 - \$50';
const feeRangeContent3 = 'Above \$50';
//gender constants

const GENDER_MALE = 'Male';
const GENDER_FEMALE = 'Female';

// -------------------------course status variables--------------------
class CourseConstants {
  static const ACTIVE_STATUS = 'Active';
  static const UNPAID_STATUS = 'Unpaid';
  static const ACCEPTED_STATUS = 'Accepted';
  static const DENIED_STATUS = 'Denied';
  static const INACTIVE_STATUS = 'Inactive';
  static const PENDING_STATUS = 'Pending';
  static const ONGOING_STATUS = 'Ongoing';
}

// -------------------------enrollment status variables--------------------
class EnrollmentConstants {
  static const ACTIVE_STATUS = 'Active';
  static const INACTIVE_STATUS = 'Inactive';
  static const ONGOING_STATUS = 'Ongoing';
}

//--------------------
class StatusConstants {
  static const ACTIVE_STATUS = 'Active';
  static const UNPAID_STATUS = 'Unpaid';
  static const ACCEPTED_STATUS = 'Accepted';
  static const DENIED_STATUS = 'Denied';
  static const INACTIVE_STATUS = 'Inactive';
  static const PENDING_STATUS = 'Pending';
  static const ONGOING_STATUS = 'Ongoing';
}

//-------------------------commission id for join course----------
const JOIN_COURSE_COMMISSION_ID = 1;
