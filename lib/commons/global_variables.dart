import 'package:intl/intl.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/models/tutor.dart';

//---------------------user authentication variables------------------------------------------------------
// tutee id for all page can access; this will be reseted when login succeed
Tutee authorizedTutee;
//
//tutor id for all page can access;
//  this will be reseted when tutor login succeeded
//authorized tutor
Tutor authorizedTutor;
//

//-------------------------------------orther common variables----------------------------------------------
//default datetime
const defaultDatetime = '1990-01-01';
//default 'No select' variable
const DEFAULT_NO_SELECT = 'No select'; 
//
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