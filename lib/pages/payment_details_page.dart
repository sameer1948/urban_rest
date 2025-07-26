// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urban_rest/database/service/paymentInvoiceService.dart';
import 'package:urban_rest/model/invoice.dart';
import 'package:urban_rest/model/paymentInvoice.dart';

class PaymentDetailsPage extends StatelessWidget {
  final PaymentInvoice paymentInvoice;

  const PaymentDetailsPage({Key? key, required this.paymentInvoice})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaymentInvoiceService paymentInvoiceService = PaymentInvoiceService();
    final dateTimeFormatter = DateFormat('dd-MM-yyyy hh:mm:ss a');
    final customer = paymentInvoice.customer;
    final booking = paymentInvoice.booking;
    final invoice = paymentInvoice.invoice;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Details')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Customer Info'),
                  _infoTile('Name', customer.name, Icons.person, Colors.blue),
                  const Divider(),
                  _infoTile('Phone', customer.phone, Icons.phone, Colors.green),
                  const Divider(),
                  _infoTile(
                    'Address',
                    customer.address,
                    Icons.home,
                    Colors.teal,
                  ),
                  const Divider(),
                  _infoTile(
                    'Security ID',
                    customer.securityId,
                    Icons.verified_user,
                    Colors.deepPurple,
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle('Usage Info'),
                  _infoTile(
                    'Bed ID',
                    booking.bedId.toString(),
                    Icons.bed,
                    Colors.brown,
                  ),
                  const Divider(),
                  _infoTile(
                    'Start Time',
                    dateTimeFormatter.format(booking.startTime),
                    Icons.access_time,
                    Colors.orange,
                  ),
                  const Divider(),
                  _infoTile(
                    'End Time',
                    dateTimeFormatter.format(booking.endTime),
                    Icons.timelapse,
                    Colors.redAccent,
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle('Bill Info'),
                  _infoTile(
                    'Bill ID',
                    invoice.id.toString(),
                    Icons.receipt_long,
                    Colors.deepOrange,
                  ),
                  const Divider(),
                  _infoTile(
                    'Amount',
                    'Rs. ${invoice.amount.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),
                  const Divider(),
                  _infoTile(
                    'Payment Date',
                    dateTimeFormatter.format(invoice.paymentDate),
                    Icons.date_range,
                    Colors.blueGrey,
                  ),
                  const Divider(),
                  _infoTile(
                    'Paid Status',
                    invoice.isPaid ? 'Paid' : 'Pending',
                    invoice.isPaid ? Icons.check_circle : Icons.pending_actions,
                    invoice.isPaid ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child:
                  invoice.isPaid
                      ? SizedBox()
                      : ElevatedButton.icon(
                        onPressed: () async {
                          int value = await paymentInvoiceService.payBill(
                            Invoice(
                              id: invoice.id,
                              bookingId: invoice.bookingId,
                              amount: invoice.amount,
                              paymentDate: DateTime.now(),
                              isPaid: true,
                            ),
                          );

                          if (value == 1) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment confirmed!'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment not confirmed!'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.limeAccent,
                        ),
                        label: const Text(
                          'Confirm Payment',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData iconData, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 20.0, color: color),
          SizedBox(width: 10.0),
          SizedBox(
            width: 180, // Fixed width for label column
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
