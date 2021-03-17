import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/class.dart';

class ClassRepository {
  //fetch classes by subject id
  Future<List<Class>> fetchClassBySubjectId(
      http.Client client, int subjectId) async {
    final response = await http.get('$CLASS_BY_SUBJECT_ID_API$subjectId');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((classes) => new Class.fromJson(classes))
          .toList();
    } else {
      print('this is error body: ' + response.body);
      throw Exception('Failed to fetch classes by class id');
    }
  }
}
