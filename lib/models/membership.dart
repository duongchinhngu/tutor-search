class Membership {
  final int id;
  final String name;
  final double pointRate;
  final int pointAmount;
  final String description;
  final String status;

  Membership({
    this.id,
    this.name,
    this.description,
    this.status,
    this.pointRate,
    this.pointAmount,
  });
  Membership.constructor(this.id, this.name, this.description,
      this.status, this.pointRate, this.pointAmount);

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'],
      name: json['name'],
      pointRate: json['pointRate'],
      pointAmount: json['pointAmount'],
      description: json['description'],
      status: json['status'],
    );
  }

  void showAttribute() {
    print('Membership name: ' + name);
    print('Membership role id: ' + pointRate.toString());
    print('Membership status: ' + status);
  }
}
