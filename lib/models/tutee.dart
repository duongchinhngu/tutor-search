import 'person.dart';

class Tutee extends Person {
  Tutee(
      {int id,
      String fullname,
      String gender,
      String birthday,
      String email,
      String phone,
      String address,
      String status,
      int roleId,
      String description,
      String avatarImageLink})
      : super(id, fullname, gender, birthday, email, phone, address, status,
            roleId, description, avatarImageLink);

  Tutee.constructor(
    int id,
    String fullname,
    String gender,
    String birthday,
    String email,
    String phone,
    String address,
    String status,
    int roleId,
    String description,
    String avatarImageLink,
  ) : super(id, fullname, gender, birthday, email, phone, address, status,
            roleId, description, avatarImageLink);

  factory Tutee.fromJson(Map<String, dynamic> json) {
    return Tutee(
      id: json['id'],
      fullname: json['fullname'],
      gender: json['gender'],
      birthday: json['birthday'].toString().substring(0, 10),
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      avatarImageLink: json['avatarImageLink'],
      status: json['status'],
      roleId: json['roleId'],
    );
  }

  void showAttributes() {
    print('this is tutor fullname: ' + fullname);
    print('this is tutor gender: ' + gender);
    print('this is tutor birthday: ' + birthday);
    print('this is tutor email: ' + email);
    print('this is tutor phone: ' + phone);
    print('this is tutor address: ' + address);
    print('this is tutor roleId: ' + roleId.toString());
    print('this is tutor avatarImageLink: ' + avatarImageLink);

  }
}
