// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:urban_rest/providers/backGroundColorProvider.dart';
import 'package:urban_rest/widgets/common_widgets.dart';
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

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      final customers = await _customerService.getAllCustomers();
      final durations = await _durationHourService.getDurationHours();

      setState(() {
        customerList = customers;
        durationHourList = durations;
        selectedDurationKey =
            durations.isNotEmpty ? durations.first.id.toString() : null;
        isLoading = false;
      });
    } catch (e) {
      SnackBarWidget.show(
        context,
        message: 'Failed to load data',
        color: Colors.red,
      );
    }
  }

  String getDurationLabel(String? id) {
    final match = durationHourList.firstWhere(
      (d) => d.id.toString() == id,
      orElse:
          () => DurationHour(
            id: 0,
            key: 'Unknown',
            value: 'Unknown',
            status: 'ACTIVE',
          ),
    );
    return match.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundColorProvider = Provider.of<Backgroundcolorprovider>(
      context,
    );
    final selectedBackGroundColor =
        backgroundColorProvider.activeBackgroundColor;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Dialog(
          backgroundColor: CommonWidgets.getTopColors(
            selectedBackGroundColor?.colorsList ?? '0xFF2193b0',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.5,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'Book Bed ${widget.bed.id}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      /// Booking Details Section (Always Visible)
                      Divider(),
                      Text(
                        'Booking Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('🛏️ Bed No: ${widget.bed.id}'),

                      /// Show customer once selected
                      if (selectedCustomer != null) ...[
                        SizedBox(height: 5),
                        Text('👤 Customer: ${selectedCustomer!.name}'),
                      ],

                      /// Show duration once selected
                      if (selectedCustomer != null &&
                          selectedDurationKey != null) ...[
                        SizedBox(height: 5),
                        Text(
                          '⏳ Duration: ${getDurationLabel(selectedDurationKey)}',
                        ),
                      ],
                      SizedBox(height: 20),

                      /// Dropdown for Customer
                      DropdownButtonFormField<Customer>(
                        decoration: InputDecoration(
                          labelText: 'Select Customer',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCustomer,
                        items:
                            customerList
                                .map(
                                  (customer) => DropdownMenuItem(
                                    value: customer,
                                    child: Text(customer.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => selectedCustomer = value);
                        },
                      ),
                      SizedBox(height: 16),

                      /// Dropdown for Duration
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Duration',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedDurationKey,
                        items:
                            durationHourList
                                .map(
                                  (duration) => DropdownMenuItem<String>(
                                    value: duration.id.toString(),
                                    child: Text(duration.value),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => selectedDurationKey = value);
                        },
                      ),
                      SizedBox(height: 20),

                      /// Save Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonWidgets.getBottomColors(
                            selectedBackGroundColor?.colorsList ?? '0xFF2193b0',
                          ),
                          // foregroundColor: CommonWidgets.getTopColors(
                          //   selectedBackGroundColor?.colorsList ?? '0xFF2193b0',
                          // ),
                        ),
                        onPressed:
                            isSaving
                                ? null
                                : () async {
                                  if (selectedCustomer == null ||
                                      selectedDurationKey == null) {
                                    SnackBarWidget.show(
                                      context,
                                      message:
                                          'Please select a customer and duration',
                                      color: Colors.orange,
                                    );
                                    return;
                                  }

                                  setState(() => isSaving = true);

                                  try {
                                    final hours =
                                        int.tryParse(
                                          selectedDurationKey ?? '1',
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
                                  } catch (e) {
                                    SnackBarWidget.show(
                                      context,
                                      message: 'Failed to book bed',
                                      color: Colors.red,
                                    );
                                  } finally {
                                    setState(() => isSaving = false);
                                  }
                                },
                        child:
                            isSaving
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text('Save'),
                      ),
                    ],
                  ),
                ),

                /// Close Icon
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.redAccent),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
