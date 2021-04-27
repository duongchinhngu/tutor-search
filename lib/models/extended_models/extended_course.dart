import '../course.dart';

class ExtendedCourse extends Course {
  String className;
  String subjectName;
  final String followDate;
  final String enrollmentStatus;
  final int enrollmentId;
  final String tutorAvatarUrl;
  final String tutorName;
  final String tutorAddress;
  final String tutorEmail;
  final bool isFeedback;
  final int availableSlot;

  ExtendedCourse(
      int id,
      String name,
      String beginTime,
      String endTime,
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
      String location,
      String extraImages,
      this.className,
      this.subjectName,
      this.followDate,
      this.enrollmentStatus,
      this.tutorAvatarUrl,
      this.tutorName,
      this.tutorEmail,
      this.enrollmentId,
      this.tutorAddress,
      this.isFeedback,
      this.availableSlot)
      : super.constructor(
          id,
          name,
          beginTime,
          endTime,
          studyFee,
          daysInWeek,
          beginDate,
          endDate,
          description,
          status,
          classHasSubjectId,
          createdBy,
          maxTutee,
          location,
          extraImages,
          createdDate,
          confirmedDate,
          confirmedBy,
        );

  ExtendedCourse.fromJsonConstructor(
      {int id,
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
      String location,
      String extraImages,
      this.tutorAddress,
      this.className,
      this.subjectName,
      this.followDate,
      this.enrollmentStatus,
      this.tutorAvatarUrl,
      this.tutorName,
      this.tutorEmail,
      this.enrollmentId,
      this.isFeedback,
      this.availableSlot})
      : super.constructor(
          id,
          name,
          beginTime,
          endTime,
          studyFee,
          daysInWeek,
          beginDate,
          endDate,
          description,
          status,
          classHasSubjectId,
          createdBy,
          maxTutee,
          location,
          extraImages,
          createdDate,
          confirmedDate,
          confirmedBy,
        );

  factory ExtendedCourse.fromJson(Map<String, dynamic> json) {
    return ExtendedCourse.fromJsonConstructor(
      id: json['id'],
      status: json['status'],
      name: json['name'],
      beginTime: json['beginTime'].toString().substring(11),
      endTime: json['endTime'].toString().substring(11),
      studyFee: json['studyFee'].toDouble(),
      daysInWeek: json['daysInWeek'],
      beginDate: json['beginDate'].toString().substring(0, 10),
      endDate: json['endDate'].toString().substring(0, 10),
      description: json['description'],
      classHasSubjectId: json['classHasSubjectId'],
      createdBy: json['createdBy'],
      confirmedBy: json['confirmedBy'],
      confirmedDate: json['confirmedDate'],
      maxTutee: json['maxTutee'],
      className: json['className'],
      subjectName: json['subjectName'],
      followDate: json['followDate'].toString(),
      enrollmentStatus: json['enrollmentStatus'].toString(),
      tutorAvatarUrl: json['tutorAvatarUrl'].toString(),
      tutorName: json['tutorName'].toString(),
      tutorEmail: json['tutorEmail'].toString(),
      enrollmentId: json['enrollmentId'],
      location: json['location'],
      extraImages: json['extraImages'],
      createdDate: json['createdDate'],
      tutorAddress: json['tutorAddress'].toString(),
      isFeedback: json['isTakeFeedback'],
      availableSlot: json['availableSlot'],
    );
  }
}
