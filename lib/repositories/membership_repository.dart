import 'dart:convert';

import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/membership.dart';
import 'package:http/http.dart' as http;

class MembershipRepository {
  //load Membership by membershipId
  Future<Membership> fetchMembershipByMembershipId(http.Client client, int membershipId) async {
    final response = await http.get('$MEMBERSHIP_API/$membershipId');
    if (response.statusCode == 200) {
      return Membership.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch membership by membership id');
    }
  }
}