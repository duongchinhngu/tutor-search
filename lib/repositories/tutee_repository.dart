import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/tutee.dart';

class TuteeRepository {
  //
  //fetch Tutee by Tutee id
  Future<Tutee> fetchTuteeByTuteeId(http.Client client, int id) async {
    final response = await http.get('$TUTEE_API/$id');
    if (response.statusCode == 200) {
      return Tutee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch Tutee by Tutee id');
    }
  }

  //fetch tutee by tutee email
  Future<Tutee> fetchTuteeByTuteeEmail(http.Client client, String email) async {
    final response = await http.get('$TUTEE_API/email/$email');
    if (response.statusCode == 200) {
      return Tutee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch Tutee by Tutee email: ' +
          response.statusCode.toString());
    }
  }

  //post tutee
  Future postTutee(Tutee tutee) async {
    tutee.showAttributes();
    final http.Response response = await http.post('$TUTEE_API',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'id': tutee.id,
            'fullname': tutee.fullname,
            'gender': tutee.gender,
            'birthday': tutee.birthday,
            'email': tutee.email,
            'phone': tutee.phone,
            'address': tutee.address,
            'status': tutee.status,
            'roleId': tutee.roleId,
            'description': tutee.description,
            'avatarImageLink': tutee.avatarImageLink,
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print('error body tutee repo: ' + response.body);
      print(response.statusCode);
      throw Exception('Faild to post Tutee');
    }
  }

  Future putTuteeUpdate(Tutee tutee, int id) async {
    final http.Response response = await http.put('$TUTEE_API/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'id': tutee.id,
            'fullname': tutee.fullname,
            'gender': tutee.gender,
            'birthday': tutee.birthday,
            'email': tutee.email,
            'phone': tutee.phone,
            'address': tutee.address,
            'status': tutee.status,
            'roleId': tutee.roleId,
            'description': tutee.description,
            'avatarImageLink': tutee.avatarImageLink,
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print('error body tutee repo: ' + response.body);
      print(response.statusCode);
      throw Exception('Faild to update Tutee');
    }
  }

  //fetch Tutee by courseId
  // ignore: dead_code
  Future<List<Tutee>> fetchTuteeByCourseId(
      http.Client client, int courseId) async {
    final response = await http.get('$TUTEE_IN_A_COURSE/$courseId');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((tutee) => new Tutee.fromJson(tutee)).toList();
    } else if (response.statusCode == 404) {
      return null;
    } else {
      print('Error body: ' + response.body);
      throw Exception(
          'Failed to fetch Tutee by courseId' + response.statusCode.toString());
    }
  }
}
