// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_rest/database/service/invoiceService.dart';
import 'package:urban_rest/database/service/paymentInvoiceService.dart';
import 'package:urban_rest/model/invoice.dart';
import 'package:urban_rest/model/paymentInvoice.dart';
import 'package:urban_rest/pages/payment_details_page.dart';
import 'package:urban_rest/providers/backGroundColorProvider.dart';
import 'package:urban_rest/widgets/common_widgets.dart';

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final PaymentInvoiceService _paymentService = PaymentInvoiceService();
  final InvoiceService _invoiceService = InvoiceService();
  List<Invoice> paidList = [];
  List<Invoice> pendingList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    showInvoices();
  }

  Future<void> showInvoices() async {
    setState(() => isLoading = true);
    var invoiceList = await _invoiceService.getAllInvoices();
    setState(() {
      paidList = invoiceList.where((invoice) => invoice.isPaid).toList();
      pendingList = invoiceList.where((invoice) => !invoice.isPaid).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final backgroundColorProvider = Provider.of<Backgroundcolorprovider>(
      context,
    );
    final selectedBackGroundColor =
        backgroundColorProvider.activeBackgroundColor;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bills'),
          backgroundColor: CommonWidgets.getTopColors(
            selectedBackGroundColor?.colorsList ?? '0xFF2193b0',
          ),
          bottom: const TabBar(
            tabs: [Tab(text: 'Bills Pending'), Tab(text: 'Bills Paid')],
          ),
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: CommonWidgets.getColors(
                selectedBackGroundColor?.colorsList ?? '0xFF2193b0,0xFF6dd5ed',
              ),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                    children: [
                      // Tab 1: Pending Bills
                      RefreshIndicator(
                        onRefresh: showInvoices,
                        color: Colors.greenAccent,
                        child:
                            pendingList.isNotEmpty
                                ? ListView.separated(
                                  padding: const EdgeInsets.all(12),
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 10),
                                  itemCount: pendingList.length,
                                  itemBuilder: (context, index) {
                                    final invoice = pendingList[index];
                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 16,
                                            ),
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              Colors.redAccent.shade100,
                                          child: const Icon(
                                            Icons.receipt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          'Bill ID: ${invoice.id}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Amount: \$${invoice.amount.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        trailing: const Text(
                                          'Pending',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder:
                                                (_) => const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                          );

                                          PaymentInvoice? paymentInvoice =
                                              await _paymentService.getDetails(
                                                invoice,
                                              );

                                          Navigator.pop(
                                            context,
                                          ); // Close loading spinner

                                          if (paymentInvoice != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        PaymentDetailsPage(
                                                          paymentInvoice:
                                                              paymentInvoice,
                                                        ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Failed to load payment details',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )
                                : const Center(
                                  child: Text(
                                    'No pending bills available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                      ),

                      // Tab 2: Bills Paid
                      RefreshIndicator(
                        onRefresh: showInvoices,
                        color: Colors.lightBlue,
                        child:
                            paidList.isNotEmpty
                                ? ListView.separated(
                                  padding: const EdgeInsets.all(12),
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 10),
                                  itemCount: paidList.length,
                                  itemBuilder: (context, index) {
                                    final invoice = paidList[index];
                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 16,
                                            ),
                                        leading: CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            107,
                                            211,
                                            137,
                                          ),
                                          child: const Icon(
                                            Icons.receipt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          'Bill ID: ${invoice.id}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Amount: Rs. ${invoice.amount.toStringAsFixed(2)}/-',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        trailing: const Text(
                                          'Paid',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              107,
                                              211,
                                              137,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder:
                                                (_) => const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                          );

                                          PaymentInvoice? paymentInvoice =
                                              await _paymentService.getDetails(
                                                invoice,
                                              );

                                          Navigator.pop(
                                            context,
                                          ); // Close loading spinner

                                          if (paymentInvoice != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        PaymentDetailsPage(
                                                          paymentInvoice:
                                                              paymentInvoice,
                                                        ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Failed to load payment details',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )
                                : const Center(
                                  child: Text(
                                    'No pending bills available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
