// ignore_for_file: file_names

import 'package:urban_rest/database/service/bookingService.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/database/service/invoiceService.dart';
import 'package:urban_rest/model/invoice.dart';
import 'package:urban_rest/model/paymentInvoice.dart';

class PaymentInvoiceService {
  final CustomerService customerService = CustomerService();
  final Bookingservice bookingService = Bookingservice();
  final InvoiceService invoiceService = InvoiceService();

  Future<PaymentInvoice?> getDetails(Invoice invoice) async {
    try {
      final booking = await bookingService.getBookingById(invoice.bookingId);
      if (booking == null) return null;

      final customer = await customerService.getCustomerById(
        booking.customerId,
      );
      if (customer == null) return null;

      return PaymentInvoice(
        customer: customer,
        booking: booking,
        invoice: invoice,
      );
    } catch (e) {
      print('Error getting PaymentInvoice details: $e');
      return null;
    }
  }

  Future<int> payBill(Invoice invoice) async {
    return await invoiceService.updateInvoice(invoice);
  }
}
