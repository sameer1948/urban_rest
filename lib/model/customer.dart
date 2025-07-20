class Customer {
  int id;
  String name;
  String phone;
  String address;
  String securityId;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.securityId,
  });

  // Create Customer from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      securityId: json['securityId'] as String,
    );
  }

  // Convert Customer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'securityId': securityId,
    };
  }
}
