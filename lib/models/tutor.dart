import 'person.dart';

class Tutor extends Person {
  String educationLevel;
  String school;
  int points;
  int membershipId;
  String socialIdUrl;

  Tutor({
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
    this.educationLevel,
    this.school,
    this.points,
    this.membershipId,
    this.socialIdUrl,
  }) : super(id, fullname, gender, birthday, email, phone, address, status,
            roleId, description, avatarImageLink);

  Tutor.constructor(
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
    this.educationLevel,
    this.school,
    this.points,
    this.membershipId,
    this.socialIdUrl,
  ) : super(id, fullname, gender, birthday, email, phone, address, status,
            roleId, description, avatarImageLink);

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
      fullname: json['fullname'],
      gender: json['gender'],
      birthday: json['birthday'].toString().substring(0, 10),
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      roleId: json['roleId'],
      avatarImageLink: json['avatarImageLink'],
      educationLevel: json['educationLevel'],
      school: json['school'],
      points: json['points'],
      membershipId: json['membershipId'],
      description: json['description'],
      socialIdUrl: json['socialIdUrl'],
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
    print('this is tutor educationLevel: ' + educationLevel);
    print('this is tutor school: ' + school);
    print('this is tutor socialIdUrl: ' + socialIdUrl);
    print('this is tutor point: $points');
  }
}
