// ignore_for_file: non_constant_identifier_names

class DurationHour {
  static final String ACTIVE = 'ACTIVE';

  int id;
  String key;
  String value;
  String status;

  DurationHour({
    required this.id,
    required this.key,
    required this.value,
    required this.status,
  });

  // Create DurationHour from JSON
  factory DurationHour.fromJson(Map<String, dynamic> json) {
    return DurationHour(
      id: json['id'],
      key: json['key'],
      value: json['value'],
      status: json['status'],
    );
  }

  // Convert DurationHour to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'key': key, 'value': value, 'status': status};
  }
}
