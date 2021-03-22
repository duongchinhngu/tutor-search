import '../course.dart';

class CourseTutor extends Course {
  final String fullname;
  final String gender;
  final String birthday;
  final String email;
  final String phone;
  final String address;
  final String avatarImageLink;

  CourseTutor.fromJsonConstructor({
    int id,
    String name,
    String beginTime,
    String endTime,
    String studyForm,
    double studyFee,
    String daysInWeek,
    String beginDate,
    String endDate,
    String description,
    String status,
    int classHasSubjectId,
    int createdBy,
    String createdDate,
    String confirmedDate,
    int confirmedBy,
    int maxTutee,
    this.fullname,
    this.gender,
    this.birthday,
    this.email,
    this.phone,
    this.address,
    this.avatarImageLink,
  }) : super(
          id,
          name,
          beginTime,
          endTime,
          studyForm,
          studyFee,
          daysInWeek,
          beginDate,
          endDate,
          description,
          status,
          classHasSubjectId,
          createdBy,
          maxTutee,
        );

  CourseTutor(
    int id,
    String name,
    String beginTime,
    String endTime,
    String studyForm,
    double studyFee,
    String daysInWeek,
    String beginDate,
    String endDate,
    String description,
    String status,
    int classHasSubjectId,
    int createdBy,
    String createdDate,
    String confirmedDate,
    int confirmedBy,
    int maxTutee,
    this.fullname,
    this.gender,
    this.birthday,
    this.email,
    this.phone,
    this.address,
    this.avatarImageLink,
  ) : super(
          id,
          name,
          beginTime,
          endTime,
          studyForm,
          studyFee,
          daysInWeek,
          beginDate,
          endDate,
          description,
          status,
          classHasSubjectId,
          createdBy,
          maxTutee,
        );

  factory CourseTutor.fromJson(Map<String, dynamic> json) {
    return CourseTutor.fromJsonConstructor(
      id: json['id'],
      fullname: json['fullname'],
      gender: json['gender'],
      birthday: json['birthday'].toString().substring(0, 10),
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      name: json['name'],
      beginTime: json['beginTime'].toString().substring(11),
      endTime: json['endTime'].toString().substring(11),
      studyForm: json['studyForm'],
      studyFee: json['studyFee'].toDouble(),
      daysInWeek: json['daysInWeek'],
      beginDate: json['beginDate'].toString().substring(0, 10),
      endDate: json['endDate'].toString().substring(0, 10),
      description: json['description'],
      classHasSubjectId: json['classHasSubjectId'],
      createdBy: json['createdBy'],
      confirmedBy: json['confirmedBy'],
      confirmedDate: json['confirmedDate'],
      createdDate: json['createdDate'],
      maxTutee: json['maxTutee'],
      avatarImageLink: json['avatarImageLink'],
    );
  }
}
