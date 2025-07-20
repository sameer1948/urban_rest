// ignore: file_names
class BedRate {
  int id;
  double pricePerHour;

  BedRate({required this.id, required this.pricePerHour});

  // Create BedRate from JSON
  factory BedRate.fromJson(Map<String, dynamic> json) {
    return BedRate(
      id: json['id'] as int,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
    );
  }

  // Convert BedRate to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'pricePerHour': pricePerHour};
  }
}
