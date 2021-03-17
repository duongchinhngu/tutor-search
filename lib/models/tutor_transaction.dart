import 'package:tutor_search_system/models/transaction.dart';

class TutorTransaction extends Transaction {
  int archievedPoints;
  final int usedPoints;
  final int feeId;
  final int tutorId;

  TutorTransaction.modelConstructor(
      int id,
      String dateTime,
      double amount,
      double totalAmount,
      String description,
      String status,
      this.feeId,
      this.archievedPoints,
      this.usedPoints,
      this.tutorId)
      : super(id, dateTime, amount, totalAmount, description, status);

  TutorTransaction(
      {int id,
      String dateTime,
      double amount,
      double totalAmount,
      String description,
      String status,
      this.archievedPoints,
      this.usedPoints,
      this.tutorId,
      this.feeId})
      : super(id, dateTime, amount, totalAmount, description, status);

  factory TutorTransaction.fromJson(Map<String, dynamic> json) {
    return TutorTransaction(
      id: json['id'],
      dateTime: json['dateTime'],
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      description: json['description'],
      status: json['status'],
      tutorId: json['tutorId'],
      feeId: json['feeId'],
      archievedPoints: json['archievedPoints'],
      usedPoints: json['usedPoints'],
    );
  }
}
