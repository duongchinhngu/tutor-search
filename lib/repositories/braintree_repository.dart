import 'dart:convert';

import 'package:tutor_search_system/commons/urls.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/models/braintree.dart';

class BraintreeRepository {
  //get braintree client token
  Future<String> getBraintreeClientToken() async {
    final response = await http.get('$BRAINTREE_API');
    return response.body;
  }

  //post braintree - check out
  Future checkOut(Braintree braintree) async {
    final http.Response response = await http.post('$BRAINTREE_API',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'amount': braintree.amount,
            'nonce': braintree.nonce,
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404 || 
        response.statusCode == 200) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print('error body Braintree repo: ' + response.body);
      print(response.statusCode);
      return false;
    }
  }
}
