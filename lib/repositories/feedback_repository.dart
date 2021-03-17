import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/feedback.dart';
import 'package:tutor_search_system/models/tutor.dart';

class FeedbackRepository {
  //add new feedback to DB
  Future postFeedback(Feedbacks feedback) async {
    final http.Response response = await http.post(FEEDBACK_API,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'id': feedback.id,
            'comment': feedback.comment,
            'tutorId': feedback.tutorId,
            // 'createdDate': feedback.createdDate,
            // 'confirmedDate': feedback.confirmedDate,
            // 'confirmedBy': feedback.confirmedBy,
            'status': feedback.status,
            'rate': feedback.rate.toInt(),
            'tuteeId': feedback.tuteeId,
          },
        ));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Faild to post Feedback');
    }
  }

  //check whether or not this authorized tutee feedback all of his/her tutor
  //return unfeedbacked tutor
  Future<Tutor> fetchUnfeedbackTutorByTuteeId(
      http.Client client, int tuteeId) async {
    final response =
        await http.get('$FEEDBACK_CHECK_API/result?tuteeId=$tuteeId');
    if (response.statusCode == 200) {
      return Tutor.fromJson(json.decode(response.body));
    } else if (response.statusCode == 500) {
      return null;
    } else {
      print('Error feedback: ' + response.body);
      throw Exception('Failed to fetch Tutor by check feedback');
    }
  }
}
