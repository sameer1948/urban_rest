// ignore_for_file: non_constant_identifier_names

class Transition {
  static final String VALUE_YES = 'YES';
  static final String VALUE_NO = 'NO';

  int id;
  String style;
  String isActive;

  Transition({required this.id, required this.style, required this.isActive});

  // Create Transition from JSON
  factory Transition.fromJson(Map<String, dynamic> json) {
    return Transition(
      id: json['id'] as int,
      style: json['style'] as String,
      isActive: json['isActive'] as String,
    );
  }

  // Convert Transition to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'style': style, 'isActive': isActive};
  }
}
