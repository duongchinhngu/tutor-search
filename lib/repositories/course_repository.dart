import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_search_system/commons/authorization.dart';
import 'package:tutor_search_system/commons/functions/common_functions.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/course.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:tutor_search_system/models/extended_models/extended_course.dart';
import 'package:tutor_search_system/models/extended_models/course_tutor.dart';
import 'package:tutor_search_system/screens/tutee_screens/home_screens/sort_course_function.dart';
import 'package:tutor_search_system/screens/tutee_screens/search_course_screens/filter_models/course_filter_variables.dart';

class CourseRepository {
  //fecth all courses : status = active and not registered by this tuteeId
  Future<List<CourseTutor>> fecthTuteeHomeCourses(
      http.Client client, String currentAddress) async {
    final tuteeId = globals.authorizedTutee.id;
    final String currentLocation = currentAddress;
    final response = await http.get(
      '$TUTEE_HOME_COURSES/$tuteeId/$currentLocation',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<CourseTutor> result = jsonResponse
          .map((courses) => new CourseTutor.fromJson(courses))
          .toList();
      result.sort((a, b) => a.distance.compareTo(b.distance));
      final prefs = await SharedPreferences.getInstance();
      //
      List<String> interestedSubjectIds = prefs.getStringList(
          'interestedSubjectsOf' + authorizedTutee.id.toString());
      //
      if (interestedSubjectIds != null) {
        return sortByInterestedSubject(interestedSubjectIds, result);
      } else {
        return result;
      }
    } else {
      print('thí í body eror: ' + response.body);
      throw Exception('Failed to fetch all courses');
    }
  }

  //fetch courses by status
  Future<List<CourseTutor>> fetchCourseByFilter(
      http.Client client, Filter filter, String currentAddress) async {
    // final String currentLocation = await getCurrentLocation();
    final String currentLocation = currentAddress;
    //host url
    String url = '$FILTER_COURSE_API/$currentLocation/filter?';
    //query parameters
    Map<String, String> queryParams = {
      'subjectId': filter.filterSubject.id.toString(),
      'tuteeId': globals.authorizedTutee.id.toString(),
      'classId': filter.filterClass.id.toString(),
      if (filter.filterStudyFee != null)
        'minFee': filter.filterStudyFee.from.toString(),
      if (filter.filterStudyFee != null &&
          filter.filterStudyFee.to != double.infinity)
        'maxFee': filter.filterStudyFee.to.toString(),
      if (filter.filterDateRange != null)
        'beginDate': convertDayTimeToString(filter.filterDateRange.start),
      if (filter.filterDateRange != null)
        'endDate': convertDayTimeToString(filter.filterDateRange.end),
      if (filter.filterTimeRange != null)
        'minTime':
            convertTimeOfDayToAPIFormatString(filter.filterTimeRange.startTime),
      if (filter.filterTimeRange != null)
        'maxTime':
            convertTimeOfDayToAPIFormatString(filter.filterTimeRange.endTime),
      if (filter.filterGender != null) 'tutorGender': filter.filterGender,
      // if (filter.filterEducationLevel != null)
      //   'educationLevel': filter.filterEducationLevel,
      if (filter.filterWeekdays != '') 'weekdays': filter.filterWeekdays,
    };
    //transform to queryTring
    String queryString = Uri(queryParameters: queryParams).query;
    url += queryString;
    print('this is query url: ' + url);
    //merge to url

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((courses) => new CourseTutor.fromJson(courses))
          .toList();
    } else if (response.statusCode == 404) {
      return null;
    } else {
      print('Error body: ' + response.body);
      throw Exception('Failed to fetch courses by filter');
    }
  }

  //fetch courses unregistered by tuteeId; by subjectId and classId
  Future<List<Course>> fetchgetUnregisteredCoursesBySubjectIdClassId(
      http.Client client, int tuteeId, int subjectId, int classId) async {
    //host url
    String url = UNREGISTERD_COURSE_BY_SUBJECT_CLASS_API;
    //query parameters
    Map<String, String> queryParams = {
      'tuteeId': tuteeId.toString(),
      'subjectId': subjectId.toString(),
      'classId': classId.toString(),
    };
    //transform to queryTring
    String queryString = Uri(queryParameters: queryParams).query;
    url += queryString;
    print('this is query url: ' + url);
    //merge to url

    final response = await http.get(
      url,
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((courses) => new Course.fromJson(courses))
          .toList();
    } else {
      print('error body: ' + response.body);
      throw Exception('Failed to fetch courses by filter');
    }
  }

  Future<String> getManagerBySubjectId(
      http.Client client, int subjectId) async {
    String test =
        'https://tutorsearchsystem.azurewebsites.net/api/managers/get-manager-email-by-subject/$subjectId';
    print('$test');
    final response = await http.get(
      'https://tutorsearchsystem.azurewebsites.net/api/managers/get-manager-email-by-subject/$subjectId',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    print('body ne: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      print('body ne: ' + response.body);
      return response.body;
    } else {
      throw Exception('Failed to fetch manager by course id');
    }
  }

  //fetch extedned courses by courseId
  Future<ExtendedCourse> fetchCourseByCourseId(
      http.Client client, int id) async {
    print('test id ne: $id');
    final response = await http.get(
      '$COURSE_API/$id',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      return ExtendedCourse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch course by course id');
    }
  }

  //gey course by id
  Future<Course> fetchCourseById(int id) async {
    final response = await http.get(
      '$COURSE_API/get/$id',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      print('Success here: ' + response.body);
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch course by course id');
    }
  }

  //fetch courses by courseId and tuteeId enroolemnt
  Future<ExtendedCourse> fetchCourseByCourseIdTuteeId(
      http.Client client, int id, int tuteeId) async {
    final response = await http.get(
      '$COURSE_API/$id?tuteeId=$tuteeId',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      return ExtendedCourse.fromJson(json.decode(response.body));
    } else {
      print('Errror here status code: ' + response.statusCode.toString());
      print('thi sis error body: ' + response.body);
      throw Exception('Failed to fetch course by course id');
    }
  }

  //fetch courses by tuteeId, enrollment status
  Future<List<Course>> fetchCoursesByTuteeId(
      http.Client client, int tuteeId) async {
    //wait for back end
    final response = await http.get(
      '$COURSES_BY_TUTEEID_API/$tuteeId',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    //wait for back end
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((courses) => new Course.fromJson(courses))
          .toList();
    } else {
      throw Exception('Failed to fetch course by course id');
    }
  }

  //fetch all courses by tutee id and enrollment status
  Future<List<ExtendedCourse>> fetchCoursesByEnrollmentStatus(
      http.Client client, String status, int tuteeId) async {
    //host url
    String url = COURSES_BY_ENROLLMENT_STATUS_API;
    //query parameters
    Map<String, String> queryParams = {
      'tuteeId': tuteeId.toString(),
      'enrollmentStatus': status,
    };
    //transform to queryTring
    String queryString = Uri(queryParameters: queryParams).query;
    url += queryString;
    //merge to url

    final response = await http.get(
      url,
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((courses) => new ExtendedCourse.fromJson(courses))
          .toList();
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch courses by filter');
    }
  }

  //fetch all courses by tutee id and enrollment status
  Future<List<Course>> fetchTutorCoursesByCourseStatus(
      http.Client client, String status, int tutorId) async {
    //host url
    String url = COURSE_API + '/tutor/courses?';
    //query parameters
    Map<String, String> queryParams = {
      'tutorId': tutorId.toString(),
      'status': status,
    };
    //transform to queryTring
    String queryString = Uri(queryParameters: queryParams).query;
    url += queryString;
    //merge to url

    final response = await http.get(
      url,
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((courses) => new Course.fromJson(courses))
          .toList();
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch tutor courses by course status');
    }
  }

  //post course
  Future postCourse(Course course) async {
    final http.Response response = await http.post(COURSE_API,
        headers: await AuthorizationContants().getAuthorizeHeader(),
        body: jsonEncode(
          <String, dynamic>{
            'id': course.id,
            'name': course.name,
            'beginTime': globals.defaultDatetime + 'T' + course.beginTime,
            'endTime': globals.defaultDatetime + 'T' + course.endTime,
            'studyFee': course.studyFee,
            'daysInWeek': course.daysInWeek,
            'beginDate': course.beginDate,
            'endDate': course.endDate,
            'description': course.description,
            'classHasSubjectId': course.classHasSubjectId,
            'createdBy': course.createdBy,
            'status': course.status,
            'maxTutee': course.maxTutee,
            'location': course.location,
            'extraImages': course.extraImages
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      return true;
    } else {
      print('this is: ' + response.body + response.statusCode.toString());
      print(response.statusCode);
      throw Exception('Faild to post Course');
    }
  }

  //update course in db
  Future<bool> putCourse(Course course) async {
    // print('this is created Date: ' + course.createdDate);
    final response = await http.put(
      '$COURSE_API/${course.id}',
      headers: await AuthorizationContants().getAuthorizeHeader(),
      body: jsonEncode(<String, dynamic>{
        'id': course.id,
        'name': course.name,
        'beginTime': globals.defaultDatetime + 'T' + course.beginTime,
        'endTime': globals.defaultDatetime + 'T' + course.endTime,
        'studyFee': course.studyFee,
        'daysInWeek': course.daysInWeek,
        'beginDate': course.beginDate,
        'endDate': course.endDate,
        'description': course.description,
        'classHasSubjectId': course.classHasSubjectId,
        'createdBy': course.createdBy,
        'createdDate': course.createdDate,
        'confirmedDate': course.confirmedDate,
        'confirmedBy': course.confirmedBy,
        'status': course.status,
        'maxTutee': course.maxTutee,
        'location': course.location,
        'extraImages': course.extraImages
      }),
    );
    if (response.statusCode == 204) {
      print('course update body: ' + response.body);
      return true;
    } else {
      print('Error course update body: ' + response.body);
      return false;
      // throw new Exception('Update course failed!: ${response.statusCode}');
    }
  }

  //check validate course
  Future<Course> checkValidate(Course course) async {
    final http.Response response = await http.post('$COURSE_API/check-validate',
        headers: await AuthorizationContants().getAuthorizeHeader(),
        body: jsonEncode(
          <String, dynamic>{
            'id': course.id,
            'name': course.name,
            'beginTime': globals.defaultDatetime + 'T' + course.beginTime,
            'endTime': globals.defaultDatetime + 'T' + course.endTime,
            'studyFee': course.studyFee,
            'daysInWeek': course.daysInWeek,
            'beginDate': course.beginDate,
            'endDate': course.endDate,
            'description': course.description,
            'classHasSubjectId': course.classHasSubjectId,
            'createdBy': course.createdBy,
            'status': course.status,
            'maxTutee': course.maxTutee,
            'location': course.location,
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      return null;
    } else if (response.statusCode == 200) {
      print('this is: ' + response.body + response.statusCode.toString());
      print(response.statusCode);
      return Course.fromJson(json.decode(response.body));
    }
  }
}
