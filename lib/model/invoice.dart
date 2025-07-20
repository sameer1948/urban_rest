class Invoice {
  final int id;
  final int bookingId;
  final double amount;
  final DateTime paymentDate;
  final bool isPaid;

  Invoice({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.paymentDate,
    required this.isPaid,
  });

  // Create Invoice from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      bookingId: json['bookingId'],
      amount: json['amount'].toDouble(),
      paymentDate: DateTime.parse(json['paymentDate']),
      isPaid: json['isPaid'] == 1,
    );
  }

  // Convert Invoice to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'isPaid': isPaid ? 1 : 0,
    };
  }
}
