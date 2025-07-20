class Booking {
  int id;
  int bedId;
  int customerId;
  DateTime startTime;
  DateTime endTime;

  Booking({
    required this.id,
    required this.bedId,
    required this.customerId,
    required this.startTime,
    required this.endTime,
  });

  // Create Booking from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      bedId: json['bedId'] as int,
      customerId: json['customerId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );
  }

  // Convert Booking to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bedId': bedId,
      'customerId': customerId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}
