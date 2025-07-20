class Bed {
  int id;
  String status;

  Bed({required this.id, required this.status});

  // Create Bed from JSON
  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(id: json['id'] as int, status: json['status'] as String);
  }

  // Convert Bed to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'status': status};
  }
}
