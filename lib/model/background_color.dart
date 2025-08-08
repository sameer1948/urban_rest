// ignore_for_file: non_constant_identifier_names

class BackgroundColor {
  static final String VALUE_YES = 'YES';
  static final String VALUE_NO = 'NO';

  int id;
  String key;
  String colorsList;
  String isActive;

  BackgroundColor({
    required this.id,
    required this.key,
    required this.colorsList,
    required this.isActive,
  });

  // Create BackgroundColor from JSON
  factory BackgroundColor.fromJson(Map<String, dynamic> json) {
    return BackgroundColor(
      id: json['id'] as int,
      key: json['key'] as String,
      colorsList: json['colorsList'] as String,
      isActive: json['isActive'] as String,
    );
  }

  // Convert BackgroundColor to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'colorsList': colorsList,
      'isActive': isActive,
    };
  }
}
