class Braintree {
  final double amount;
  final String nonce;

  Braintree.constructor(this.amount, this.nonce);

  Braintree({this.amount, this.nonce});

  factory Braintree.fromJson(Map<String, dynamic> json) {
    return Braintree(
      amount: json['amount'],
      nonce: json['nonce'],
    );
  }
}
