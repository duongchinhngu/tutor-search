const SERVER_NAME = "https://tutorsearchsystem.azurewebsites.net/api";

//tutor api urls
const TUTOR_API = "$SERVER_NAME/tutors";

//tutee api urls
const TUTEE_API = "$SERVER_NAME/tutees";
const UPDATE_TUTEE_API = "$SERVER_NAME/tutees/id?";

const TUTEE_IN_A_COURSE = '$TUTEE_API/tutee-in-course';

//class api urls
const CLASS_API = "$SERVER_NAME/classes";
const ALL_CLASS_API = "$CLASS_API/all";
const CLASS_BY_SUBJECT_ID_STATUS_API = "$CLASS_API/subject/status";

//course api urls
const COURSE_API = "$SERVER_NAME/courses";
const ALL_COURSE_API = "$COURSE_API/all";
const FILTER_COURSE_API = "$COURSE_API/filter/filter?";
const UNREGISTERD_COURSE_BY_SUBJECT_CLASS_API =
    "$COURSE_API/tutee/subject/class/result?";
const COURSES_BY_TUTEEID_API = "$COURSE_API/courses-by-tutee-id";
const COURSES_BY_ENROLLMENT_STATUS_API =
    "$COURSE_API/courses-by-enrollment-status/courses?";
const TUTEE_HOME_COURSES = '$COURSE_API/tutee-home';

//subject api urls
const SUBJECT_API = "$SERVER_NAME/subjects";
const ALL_SUBJECT_API = "$SUBJECT_API/all";
const SUBJECT_BY_STATUS_API = "$SUBJECT_API/status";

//enrollment api urls
const ENROLLMENT_API = "$SERVER_NAME/enrollments";

//account api urls
const ACCOUNT_API = "$SERVER_NAME/accounts";

//fee api urls
const FEE_API = "$SERVER_NAME/fees";

//Transaction api urls
const TUTEE_TRANSACTION_API = "$SERVER_NAME/tutee-transactions";
const TUTOR_TRANSACTION_API = "$SERVER_NAME/tutor-transactions";

//class has subject api urls
const CLASS_HAS_SUBJECT_API = "$SERVER_NAME/class-has-subject";
const SEARCH_CLASS_HAS_SUBJECT_API = "$CLASS_HAS_SUBJECT_API/search";

//image api urls
const IMAGE_API = '$SERVER_NAME/images';

//feedback api url
const FEEDBACK_API = '$SERVER_NAME/feedbacks';
const FEEDBACK_CHECK_API = '$FEEDBACK_API/check-exist';

//membership api ulrs
const MEMBERSHIP_API = '$SERVER_NAME/memberships';

//braintree payment api
const BRAINTREE_API = '$SERVER_NAME/braintree-payment';
