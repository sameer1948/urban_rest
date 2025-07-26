// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:urban_rest/database/service/bedRateService.dart';
import 'package:urban_rest/database/service/bookingService.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/database/service/invoiceService.dart';
import 'package:urban_rest/model/booking.dart';
import 'package:urban_rest/model/customer.dart';
import 'package:urban_rest/model/invoice.dart';
import 'package:urban_rest/widgets/timer_card_widget.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final CustomerService _customerService = CustomerService();
  final InvoiceService _invoiceservice = InvoiceService();
  List<Customer> customersList = [];

  final Bookingservice _bookingservice = Bookingservice();
  List<Booking> usagesList = [];
  List<Booking> occupiedUsagesList = [];
  List<Booking> completedUsagesList = [];

  final BedRateservice _bedRateservice = BedRateservice();
  double ratePerHour = 0;

  Map<String, String> durationOptions = {
    '1': '1 Hour',
    '2': '2 Hours',
    '4': '4 Hours',
    '8': '8 Hours',
    '12': 'Overnight',
    '24': 'Day',
  };

  @override
  void initState() {
    super.initState();
    showCustomers();
    showBookings();
  }

  void showCustomers() async {
    // Logic to fetch all customers
    var allCustomers = await _customerService.getAllCustomers();
    setState(() {
      customersList = allCustomers;
    });
  }

  void showBookings() async {
    var bookings = await _bookingservice.getAllBookings();
    setState(() {
      usagesList = bookings;
      occupiedUsagesList =
          bookings
              .where((usage) => usage.endTime.isAfter(DateTime.now()))
              .toList();
      completedUsagesList =
          bookings
              .where((usage) => usage.endTime.isBefore(DateTime.now()))
              .toList();
    });
  }

  void fetchBedRate() async {
    var bedRate = await _bedRateservice.getBedRateById(1);
    ratePerHour = bedRate!.pricePerHour;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status'),
          bottom: const TabBar(
            tabs: [Tab(text: "Occupied"), Tab(text: "Completed")],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Usages
            RefreshIndicator(
              onRefresh: () async {
                showBookings();
              },
              color: Colors.greenAccent,
              backgroundColor: Colors.white,
              displacement: 50,
              edgeOffset: 50,
              child: ListView.builder(
                itemCount: occupiedUsagesList.length,
                itemBuilder: (context, index) {
                  final item = occupiedUsagesList[index];
                  return TimerCardWidget(
                    bedNo: item.bedId.toString(),
                    customerName: fetchCustomerName(item.customerId),
                    startTime: item.startTime,
                    endTime: item.endTime,
                    onEnd: () async {
                      // Insert a new Invoice for the completed usage
                      var invoiceId =
                          DateTime.now().millisecondsSinceEpoch ~/ 1000;
                      await _invoiceservice.insertInvoice(
                        Invoice(
                          id: invoiceId,
                          bookingId: item.id,
                          amount: calculateTotalAmount(
                            item.startTime,
                            DateTime.now(),
                          ),
                          paymentDate: DateTime.now(),
                          isPaid: false,
                        ),
                      );
                      await _bookingservice.updateEndTime(
                        item.id,
                        DateTime.now(),
                      );
                      showBookings();
                    },
                    onExtend: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => getDropdown(item),
                      );
                      showBookings();
                    },
                  );
                },
              ),
            ),

            // Tab 2: Customers
            RefreshIndicator(
              onRefresh: () async {
                showBookings();
              },
              color: Colors.blue,
              backgroundColor: Colors.white,
              displacement: 50,
              edgeOffset: 50,

              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: completedUsagesList.length,
                itemBuilder: (context, index) {
                  final item = completedUsagesList[index];
                  return TimerCardWidget(
                    bedNo: item.bedId.toString(),
                    customerName: fetchCustomerName(item.customerId),
                    startTime: item.startTime,
                    endTime: item.endTime,
                    onEnd: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Session Already ended for ${item.customerId}',
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    onExtend: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Can\'t Extend ended session'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalAmount(DateTime startDate, DateTime endDate) {
    Duration duration = endDate.difference(startDate);
    int billable = duration.inHours;
    if (billable < 4) {
      return 40.00; // Minimum charge for less than 4 hours
    }
    return billable * ratePerHour;
  }

  String fetchCustomerName(int customerId) {
    var where = customersList.where((cust) => cust.id == customerId);

    if (where.isNotEmpty) {
      return where.first.name;
    } else {
      return 'Unknown';
    }
  }

  Widget getDropdown(Booking booking) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String? selectedDurationKey;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: screenWidth * 0.8, // 80% of screen width
        height: screenHeight * 0.3, // 60% of screen height
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Please Select Duration',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Duration',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedDurationKey,
                    items:
                        durationOptions.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDurationKey = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      if (selectedDurationKey != null) {
                        final hours =
                            int.tryParse(selectedDurationKey ?? '0') ?? 1;
                        int value = await _bookingservice.updateEndTime(
                          booking.id,
                          booking.endTime.add(Duration(hours: hours)),
                        );
                        if (value == 1) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Duration extended by ${durationOptions[selectedDurationKey]}.',
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No Chnages Are Made')),
                        );
                      }
                      selectedDurationKey = null;
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
