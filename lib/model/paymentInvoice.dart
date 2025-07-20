// ignore: file_names
import 'package:urban_rest/model/booking.dart';
import 'package:urban_rest/model/customer.dart';
import 'package:urban_rest/model/invoice.dart';

class PaymentInvoice {
  final Customer customer;
  final Booking booking;
  final Invoice invoice;

  PaymentInvoice({
    required this.customer,
    required this.booking,
    required this.invoice,
  });

  // Create PaymentInvoice from JSON
  factory PaymentInvoice.fromJson(Map<String, dynamic> json) {
    return PaymentInvoice(
      customer: Customer.fromJson(json['customer']),
      booking: Booking.fromJson(json['booking']),
      invoice: Invoice.fromJson(json['invoice']),
    );
  }

  // Convert PaymentInvoice to JSON
  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(),
      'booking': booking.toJson(),
      'invoice': invoice.toJson(),
    };
  }
}
