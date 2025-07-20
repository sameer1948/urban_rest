// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:urban_rest/constants/widgetConstants.dart';
import 'package:urban_rest/database/service/bookingService.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/model/bed.dart';
import 'package:urban_rest/model/booking.dart';
import 'package:urban_rest/model/customer.dart';
import 'package:urban_rest/widgets/snack_bar_widget.dart';

class BedBookingWidget extends StatefulWidget {
  final Bed bed;

  const BedBookingWidget({Key? key, required this.bed}) : super(key: key);

  @override
  _BedBookingWidgetState createState() => _BedBookingWidgetState();
}

class _BedBookingWidgetState extends State<BedBookingWidget> {
  final Bookingservice _bookingservice = Bookingservice();
  final CustomerService _customerService = CustomerService();
  List<Customer> customerList = [];
  Customer? selectedCustomer;

  Map<String, String> durationOptions = {
    '1': '1 Hour',
    '2': '2 Hours',
    '4': '4 Hours',
    '8': '8 Hours',
    '12': 'Overnight',
    '24': 'Day',
  };
  String? selectedDurationKey;

  @override
  void initState() {
    super.initState();
    selectedDurationKey = '1'; // Default to 1 Hour
    showCustomers(); // Load customers when dialog is initialized
  }

  void showCustomers() async {
    var allCustomers = await _customerService.getAllCustomers();
    setState(() {
      customerList = allCustomers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return customerList.isEmpty
        ? Center(child: Text('Please add Customer before Booking'))
        : Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: screenWidth * 0.8, // 80% of screen width
            height: screenHeight * 0.6, // 60% of screen height
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child:
                      customerList.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Book Bed ${widget.bed.id}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),

                              DropdownButtonFormField<Customer>(
                                decoration: InputDecoration(
                                  labelText: 'Select Customer',
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedCustomer,
                                items:
                                    customerList
                                        .map(
                                          (customer) =>
                                              DropdownMenuItem<Customer>(
                                                value: customer,
                                                child: Text(customer.name),
                                              ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCustomer = value;
                                  });
                                },
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
                              if (selectedCustomer != null &&
                                  selectedDurationKey != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    Text(
                                      'Booking Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text('🛏️ Bed No: ${widget.bed.id}'),
                                    Text(
                                      '👤 Customer: ${selectedCustomer!.name}',
                                    ),
                                    Text(
                                      '⏳ Duration: ${durationOptions[selectedDurationKey!]}',
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (selectedCustomer != null &&
                                      selectedDurationKey != null) {
                                    //var i = await _usageService.countUsages();
                                    final hours =
                                        int.tryParse(
                                          selectedDurationKey ?? '0',
                                        ) ??
                                        1;
                                    await _bookingservice.insertBooking(
                                      Booking(
                                        id: Widgetconstants.formatDateTimeToInt(),
                                        bedId: widget.bed.id,
                                        customerId: selectedCustomer!.id,
                                        startTime: DateTime.now(),
                                        endTime: DateTime.now().add(
                                          Duration(hours: hours),
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                    SnackBarWidget.show(
                                      context,
                                      message:
                                          'Bed ${widget.bed.id} booked for ${selectedCustomer!.name}',
                                      color: Colors.green,
                                    );
                                  } else {
                                    SnackBarWidget.show(
                                      context,
                                      message: 'Please select a customer',
                                      color: Colors.orange,
                                    );
                                  }
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
