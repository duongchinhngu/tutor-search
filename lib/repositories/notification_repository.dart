import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/commons/authorization.dart';
import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/notification.dart';

class NotificationRepository {
  //fetch classes by subject id
  Future<List<Notification>> fetchNotificationByEmail(
      http.Client client, String email) async {
    final response = await http.get(
      '$NOTIFICATION_API/email/$email',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((notificationes) => new Notification.fromJson(notificationes))
          .toList();
    } else if (response.statusCode == 404) {
      return null;
    } else {
      print('this is error body: ' + response.statusCode.toString());
      throw Exception('Failed to fetch Notificationes by emailId');
    }
  }

  Future postNotification(String title, String message, String email) async {
    final http.Response response = await http.post('$NOTIFICATION_API',
        headers: await AuthorizationContants().getAuthorizeHeader(),
        body: jsonEncode(<String, dynamic>{
          'id': 0,
          'title': title,
          'message': message,
          'createDate': '2021-04-24',
          'sendToUser': email,
          'isRead': true
        }));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print(response.statusCode);
      print('huhu $title');
      print('hic hic $email');
      print('sai ne: ' + response.body + response.statusCode.toString());
      throw Exception('Failed to post CreateCourseSuccessNotification');
    }
  }

  Future postCreateAccountSuccessNotification() async {
    final http.Response response = await http.post('$NOTIFICATION_API',
        headers: await AuthorizationContants().getAuthorizeHeader(),
        body: jsonEncode(<String, dynamic>{
          'id': 0,
          'title': 'Account Status',
          'message':
              'Have a new creating account tutor request need to approve !',
          'createDate': '2021-04-24',
          'sendToUser': 'datndse62825@fpt.edu.vn',
          'isRead': true
        }));
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      print('this is: ' + response.body + response.statusCode.toString());
      return true;
    } else {
      print(response.statusCode);
      print('this is: ' + response.body + response.statusCode.toString());
      throw Exception('Failed to post CreateCourseSuccessNotification');
    }
  }
}
