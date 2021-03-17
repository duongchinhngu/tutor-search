class Enrollment {
  final int id;
  final int tuteeId;
  final int courseId;
  final String description;
  String status;
  String createdDate;
  String confirmedDate;

  Enrollment.modelConstructor(
      this.id, this.tuteeId, this.courseId, this.description, this.status);

  Enrollment({
    this.id,
    this.tuteeId,
    this.courseId,
    this.description,
    this.status,
    this.createdDate,
    this.confirmedDate,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      tuteeId: json['tuteeId'],
      courseId: json['courseId'],
      description: json['description'],
      status: json['status'],
      createdDate: json['createdDate'],
      confirmedDate: json['confirmedDate'],
    );
  }
}
