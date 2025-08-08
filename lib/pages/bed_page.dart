// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_rest/constants/widgetConstants.dart';
import 'package:urban_rest/database/service/bedRateService.dart';
import 'package:urban_rest/database/service/bedService.dart';
import 'package:urban_rest/model/bed.dart';
import 'package:urban_rest/model/bedStatus.dart';
import 'package:urban_rest/providers/backGroundColorProvider.dart';
import 'package:urban_rest/widgets/bed_booking_widget.dart';
import 'package:urban_rest/widgets/bed_widget.dart';

class BedPage extends StatefulWidget {
  const BedPage({super.key});

  @override
  State<BedPage> createState() => _BedPageState();
}

class _BedPageState extends State<BedPage> {
  final BedService _bedService = BedService();
  final BedRateservice _bedRateService = BedRateservice();

  List<Bed> bedList = [];
  int rate = 0; // Default rate, will be updated after fetching from DB
  //Map<int, bool> bedAvailability = {}; // Available is true, occupied is false
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initBeds();
  }

  // Future<void> _initBeds() async {
  //   try {
  //     setState(() => isLoading = true);

  //     final beds = await _bedService.getAllBeds();

  //     final rateById = await _bedRateService.getBedRateById(1);

  //     final availabilityMap = <int, bool>{};

  //     for (var bed in beds) {
  //       availabilityMap[bed.id] = bed.status == BedStatus.available;
  //     }

  //     setState(() {
  //       bedList = beds;
  //       bedAvailability = availabilityMap;
  //       rate = rateById?.pricePerHour.toInt() ?? 0;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() => isLoading = false);

  //     if (context.mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Error loading beds: $e')));
  //     }
  //   }
  // }

  Future<void> _initBeds() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);

      final beds = await _bedService.getAllBeds();
      final rateById = await _bedRateService.getBedRateById(1);

      // final availabilityMap = <int, bool>{};
      // for (var bed in beds) {
      //   availabilityMap[bed.id] = bed.status == BedStatus.available;
      // }

      if (!mounted) return;
      setState(() {
        bedList = beds;
        //bedAvailability = availabilityMap;
        rate = rateById?.pricePerHour.toInt() ?? 0;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading beds: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<Backgroundcolorprovider>(
      context,
    );
    final selectedBackGroundColor =
        backgroundColorProvider.activeBackgroundColor;
    return Scaffold(
      appBar: AppBar(title: const Text('Available Beds')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _initBeds, // Reload the beds and availability
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        '                      Per Hour Rates: Rs. $rate.0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Center(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children:
                              bedList.map((bed) {
                                return Column(
                                  children: [
                                    Material(
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        splashColor: Colors.green.withOpacity(
                                          0.5,
                                        ),
                                        highlightColor: Colors.green
                                            .withOpacity(0.2),
                                        onTap: () async {
                                          if (bed.status ==
                                              BedStatus.available) {
                                            await showDialog(
                                              context: context,
                                              builder:
                                                  (context) => BedBookingWidget(
                                                    bed: bed,
                                                  ),
                                            );
                                            await _initBeds(); // Refresh availability after booking
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Bed ${bed.id} is occupied',
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: BedWidget.getBedIcon(
                                            Widgetconstants.BED_ICON,
                                            bed.status == BedStatus.available
                                                ? Colors.green
                                                : Colors.red,
                                            50,
                                            50,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${bed.id}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     //await _rateService.insertRate(Rate(id: 1, pricePerHour: 10.0));
      //     //Get all beds
      //     int count = await _bedService.countBeds();
      //     print('Total beds in DB : ${count}');

      //     await _bedService.insertBed(Bed(id: count + 1));
      //     _initBeds(); // Refresh beds and rates
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
