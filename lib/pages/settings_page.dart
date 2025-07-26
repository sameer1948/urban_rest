// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/service/bedService.dart';
import 'package:urban_rest/database/service/commonServices.dart';
import 'package:urban_rest/model/bed.dart';
import 'package:urban_rest/model/bedStatus.dart';

import 'package:urban_rest/widgets/snack_bar_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Commonservices _commonServices = Commonservices();
  final BedService _bedServices = BedService();

  int totalBeds = 0;

  @override
  void initState() {
    super.initState();
    getCounts();
  }

  void getCounts() async {
    totalBeds = await _commonServices.getRowCount(DatabaseConstants.TABLE_BED);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              'Bed Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shadowColor: Colors.amberAccent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Beds:  $totalBeds',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.lightGreenAccent,
                        size: 30,
                      ),
                      onPressed: () async {
                        var i = await _bedServices.insertBed(
                          Bed(id: totalBeds + 1, status: BedStatus.available),
                        );
                        if (i == -1) {
                          SnackBarWidget.show(
                            context,
                            message: 'Failed Save Bed!',
                            color: Colors.red,
                            duration: Duration(seconds: 2),
                          );
                        } else {
                          SnackBarWidget.show(
                            context,
                            message: 'New Bed Added!',
                            color: Colors.green,
                            duration: Duration(seconds: 2),
                          );
                          setState(() {
                            getCounts();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bed Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shadowColor: Colors.amberAccent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Beds:  $totalBeds',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.lightGreenAccent,
                        size: 30,
                      ),
                      onPressed: () async {
                        var i = await _bedServices.insertBed(
                          Bed(id: totalBeds + 1, status: BedStatus.available),
                        );
                        if (i == -1) {
                          SnackBarWidget.show(
                            context,
                            message: 'Failed Save Bed!',
                            color: Colors.red,
                            duration: Duration(seconds: 2),
                          );
                        } else {
                          SnackBarWidget.show(
                            context,
                            message: 'New Bed Added!',
                            color: Colors.green,
                            duration: Duration(seconds: 2),
                          );
                          setState(() {
                            getCounts();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bed Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shadowColor: Colors.amberAccent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Beds:  $totalBeds',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.lightGreenAccent,
                        size: 30,
                      ),
                      onPressed: () async {
                        var i = await _bedServices.insertBed(
                          Bed(id: totalBeds + 1, status: BedStatus.available),
                        );
                        if (i == -1) {
                          SnackBarWidget.show(
                            context,
                            message: 'Failed Save Bed!',
                            color: Colors.red,
                            duration: Duration(seconds: 2),
                          );
                        } else {
                          SnackBarWidget.show(
                            context,
                            message: 'New Bed Added!',
                            color: Colors.green,
                            duration: Duration(seconds: 2),
                          );
                          setState(() {
                            getCounts();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bed Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shadowColor: Colors.amberAccent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Beds:  $totalBeds',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.lightGreenAccent,
                        size: 30,
                      ),
                      onPressed: () async {
                        var i = await _bedServices.insertBed(
                          Bed(id: totalBeds + 1, status: BedStatus.available),
                        );
                        if (i == -1) {
                          SnackBarWidget.show(
                            context,
                            message: 'Failed Save Bed!',
                            color: Colors.red,
                            duration: Duration(seconds: 2),
                          );
                        } else {
                          SnackBarWidget.show(
                            context,
                            message: 'New Bed Added!',
                            color: Colors.green,
                            duration: Duration(seconds: 2),
                          );
                          setState(() {
                            getCounts();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
