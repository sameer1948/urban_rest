// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:urban_rest/constants/widgetConstants.dart';
import 'package:urban_rest/database/service/bedService.dart';
import 'package:urban_rest/database/service/bookingService.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/database/service/durationService.dart';
import 'package:urban_rest/model/bed.dart';
import 'package:urban_rest/model/bedStatus.dart';
import 'package:urban_rest/model/booking.dart';
import 'package:urban_rest/model/customer.dart';
import 'package:urban_rest/model/duration_hour.dart';
import 'package:urban_rest/widgets/snack_bar_widget.dart';

class BedBookingWidget extends StatefulWidget {
  final Bed bed;

  const BedBookingWidget({Key? key, required this.bed}) : super(key: key);

  @override
  _BedBookingWidgetState createState() => _BedBookingWidgetState();
}

class _BedBookingWidgetState extends State<BedBookingWidget> {
  final BedService _bedService = BedService();
  final Bookingservice _bookingservice = Bookingservice();
  final DurationHourService _durationHourService = DurationHourService();
  final CustomerService _customerService = CustomerService();
  List<Customer> customerList = [];
  Customer? selectedCustomer;
  List<DurationHour> durationHourList = [];
  String? selectedDurationKey;

  @override
  void initState() {
    super.initState();
    selectedDurationKey = '1'; // Default to 1 Hour
    showCustomers(); // Load customers when dialog is initialized
    showDurationHours();
  }

  Future<void> showCustomers() async {
    var allCustomers = await _customerService.getAllCustomers();
    setState(() {
      customerList = allCustomers;
    });
  }

  Future<void> showDurationHours() async {
    var list = await _durationHourService.getDurationHours();
    setState(() {
      durationHourList = list;
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
                                    durationHourList
                                        .map(
                                          (durationHour) =>
                                              DropdownMenuItem<String>(
                                                value:
                                                    durationHour.id.toString(),
                                                child: Text(durationHour.value),
                                              ),
                                        )
                                        .toList(),

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
                                    Text('⏳ Duration: $selectedDurationKey!'),
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
                                    await _bedService.updateBed(
                                      Bed(
                                        id: widget.bed.id,
                                        status: BedStatus.occupied,
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
