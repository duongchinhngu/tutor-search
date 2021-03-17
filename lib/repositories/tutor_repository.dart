import 'dart:convert';

import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/tutor.dart';
import 'package:http/http.dart' as http;

class TutorRepository {
  //fetch tutor by tutor id
  Future<Tutor> fetchTutorByTutorId(http.Client client, int id) async {
    final response = await http.get('$TUTOR_API/$id');
    if (response.statusCode == 200) {
      return Tutor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch Tutor by Tutor id');
    }
  }

  //fetch tutor by tutor email
  Future<Tutor> fetchTutorByTutorEmail(http.Client client, String email) async {
    final response = await http.get('$TUTOR_API/email/$email');
    if (response.statusCode == 200) {
      return Tutor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch Tutor by Tutor email');
    }
  }

  //post tutor
  Future postTutor(Tutor tutor) async {
    final http.Response response = await http.post('$TUTOR_API',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'id': tutor.id,
            'fullname': tutor.fullname,
            'gender': tutor.gender,
            'birthday': tutor.birthday,
            'email': tutor.email,
            'phone': tutor.phone,
            'address': tutor.address,
            'status': tutor.status,
            'roleId': tutor.roleId,
            'description': tutor.description,
            'avatarImageLink': tutor.avatarImageLink,
            'educationLevel': tutor.educationLevel,
            'school': tutor.school,
            'points': tutor.points,
            'membershipId': tutor.membershipId,
            'socialIdUrl': tutor.socialIdUrl,
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print('error body tutor repo: ' + response.body);
      print(response.statusCode);
      throw Exception('Faild to post Tutor');
    }
  }

  //update tutor in db
  Future<bool> putTutor(Tutor tutor) async {
    final response = await http.put(
      '$TUTOR_API/${tutor.id}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "description": tutor.description,
        "status": tutor.status,
        "fullname": tutor.fullname,
        "gender": tutor.gender,
        "birthday": tutor.birthday,
        "email": tutor.email,
        "phone": tutor.phone,
        "avatarImageLink": tutor.avatarImageLink,
        "address": tutor.address,
        "roleId": tutor.roleId,
        "id": tutor.id,
        "educationLevel": tutor.educationLevel,
        "school": tutor.school,
        "points": tutor.points,
        "membershipId": tutor.membershipId,
        "socialIdUrl": tutor.socialIdUrl,
      }),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Error tutor update body: ' + response.body);
      throw new Exception('Update tutor failed!: ${response.statusCode}' );
    }
  }
}
