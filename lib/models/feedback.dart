class Feedbacks {
  final int id;
  final String comment;
  final int tutorId;
  final int tuteeId;
  final double rate;
  // final String createdDate;
  // final String confirmedDate;
  // final int confirmedBy;
  final String status;

  Feedbacks({
    this.id,
    this.comment,
    this.tutorId,
    // this.createdDate,
    this.status,
    this.tuteeId,
    this.rate,
    // this.confirmedDate,
    // this.confirmedBy,
  });
  Feedbacks.constructor(
    this.id,
    this.comment,
    this.tutorId,
    // this.createdDate,
    this.status,
    this.tuteeId,
    this.rate,
    // this.confirmedDate,
    // this.confirmedBy,
  );

  factory Feedbacks.fromJson(Map<String, dynamic> json) {
    return Feedbacks(
      id: json['id'],
      comment: json['comment'],
      tutorId: json['tutorId'],
      // createdDate: json['createdDate'],
      rate: json['rate'],
      tuteeId: json['tuteeId'],
      status: json['status'],
      // confirmedDate: json['confirmedDate'],
      // confirmedBy: json['confirmedBy'],
    );
  }

  void showAttribute() {
    print('Feedbacks comment: ' + comment);
    print('Feedbacks role id: ' + tutorId.toString());
    print('Feedbacks status: ' + status);
  }
}
