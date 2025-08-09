// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/service/backgroundColorService.dart';
import 'package:urban_rest/database/service/bedRateService.dart';
import 'package:urban_rest/database/service/bedService.dart';
import 'package:urban_rest/database/service/commonService.dart';
import 'package:urban_rest/database/service/durationService.dart';
import 'package:urban_rest/database/service/transitionService.dart';
import 'package:urban_rest/model/background_color.dart';
import 'package:urban_rest/model/bed.dart';
import 'package:urban_rest/model/bedRate.dart';
import 'package:urban_rest/model/bedStatus.dart';
import 'package:urban_rest/model/duration_hour.dart';
import 'package:urban_rest/model/transition.dart';
import 'package:urban_rest/providers/backGroundColorProvider.dart';
import 'package:urban_rest/providers/transition_provider.dart';
import 'package:urban_rest/widgets/common_widgets.dart';
import 'package:urban_rest/widgets/snack_bar_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Backgroundcolorservice _backgroundcolorservice =
      Backgroundcolorservice();
  final Commonservice _commonServices = Commonservice();
  final Transitionservice _transitionservice = Transitionservice();
  final BedService _bedService = BedService();
  final BedRateservice _bedRateService = BedRateservice();
  final DurationHourService _durationHourService = DurationHourService();

  int totalBeds = 0;
  double ratePerHour = 0.0;
  final TextEditingController _rateController = TextEditingController();
  final FocusNode _rateFocusNode = FocusNode();
  bool isRateChanged = false;
  Transition? selectedTransition;
  List<Transition> transitionList = [];
  DurationHour? selectedDurationHour;
  List<DurationHour> durationHourList = [];
  List<BackgroundColor> backgroundColorList = [];
  BackgroundColor? selectedBackGroundColor;

  @override
  void initState() {
    super.initState();
    getCounts();
    loadRatePerHour();
    getTransitions();
    getDurationHours();
    getBackgroundcolors();

    _rateFocusNode.addListener(() {
      if (!_rateFocusNode.hasFocus) {
        // Reset text field if value not saved when losing focus
        final currentValue = double.tryParse(_rateController.text);
        if (currentValue != null &&
            currentValue.toStringAsFixed(2) != ratePerHour.toStringAsFixed(2)) {
          setState(() {
            _rateController.text = ratePerHour.toStringAsFixed(2);
            isRateChanged = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _rateFocusNode.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void getCounts() async {
    int count = await _commonServices.getRowCount(DatabaseConstants.TABLE_BED);
    setState(() {
      totalBeds = count;
    });
  }

  void loadRatePerHour() async {
    var defaultRate = 0.0;
    BedRate? bedRate = await _bedRateService.getBedRateById(1);

    if (bedRate == null) {
      await _bedRateService.insertRate(
        BedRate(id: 1, pricePerHour: defaultRate),
      );
    }

    setState(() {
      ratePerHour = bedRate?.pricePerHour ?? defaultRate;
      _rateController.text = ratePerHour.toStringAsFixed(2);
    });
  }

  void saveRatePerHour() async {
    double newRate = double.tryParse(_rateController.text) ?? ratePerHour;

    int? value = await _bedRateService.updateBedRate(
      BedRate(id: 1, pricePerHour: newRate),
    );

    if (value != null && value >= 1) {
      setState(() {
        ratePerHour = newRate;
        _rateController.text = ratePerHour.toStringAsFixed(2);
        isRateChanged = false;
      });

      // Hide keyboard
      FocusScope.of(context).unfocus();

      SnackBarWidget.show(
        context,
        message: 'Rate updated successfully!',
        color: Colors.green,
        duration: Duration(seconds: 2),
      );
    } else {
      SnackBarWidget.show(
        context,
        message: 'Failed to update rate!',
        color: Colors.red,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> getTransitions() async {
    var list = await _transitionservice.getAllTransitions();
    setState(() {
      transitionList = list;
      selectedTransition = list.firstWhere(
        (transition) => transition.isActive == Transition.VALUE_YES,
      );
    });
  }

  Future<void> getDurationHours() async {
    var list = await _durationHourService.getDurationHours();
    setState(() {
      durationHourList = list;
    });
  }

  Future<void> getBackgroundcolors() async {
    var list = await _backgroundcolorservice.getBackgroundColors();
    setState(() {
      backgroundColorList = list;
      selectedBackGroundColor = backgroundColorList.firstWhere(
        (c) => c.isActive == BackgroundColor.VALUE_YES,
        orElse: () => backgroundColorList.first,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Section 1: Rate Per Hour
              Text(
                '   Rate Per Hour',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 6,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _rateController,
                        focusNode: _rateFocusNode,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter rate per hour',
                          prefixIcon: Icon(Icons.currency_rupee),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final parsed = double.tryParse(value);
                          setState(() {
                            isRateChanged =
                                parsed != null &&
                                parsed.toStringAsFixed(2) !=
                                    ratePerHour.toStringAsFixed(2);
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: isRateChanged,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save'),
                          onPressed: saveRatePerHour,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(),

              // Section 2: Hours Status
              Text(
                '   Hours Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 8,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    children: [
                      // Dropdown takes most of the space
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<DurationHour>(
                          decoration: InputDecoration(
                            labelText: 'Duration Options',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          value: selectedDurationHour,
                          items:
                              durationHourList
                                  .map(
                                    (durationHour) =>
                                        DropdownMenuItem<DurationHour>(
                                          value: durationHour,
                                          child: Text(durationHour.value),
                                        ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedDurationHour = value;
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 12),
                      // Icon buttons aligned to the right
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.do_disturb_on,
                                color: Colors.red.shade400,
                                size: 32,
                              ),
                              tooltip: 'Disable',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_time,
                                color: Colors.greenAccent.shade400,
                                size: 32,
                              ),
                              tooltip: 'Add',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(),

              // Section 3: Bed Status
              Text(
                '   Bed Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 8,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hotel, color: Colors.deepPurple, size: 30),
                          SizedBox(width: 10),
                          Text(
                            'Total Beds: $totalBeds',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.greenAccent.shade400,
                          size: 32,
                        ),
                        tooltip: 'Add New Bed',
                        onPressed: () async {
                          var i = await _bedService.insertBed(
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
                            getCounts();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Divider(),
              const SizedBox(height: 10),

              // Section 4 : Transitions
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField<Transition>(
                  decoration: InputDecoration(
                    labelText: 'Transitions',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedTransition,
                  items:
                      transitionList.map((transition) {
                        return DropdownMenuItem<Transition>(
                          value: transition,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transition.style,
                                style: TextStyle(fontSize: 16),
                              ),
                              if (transition == selectedTransition)
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 26,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (Transition? value) async {
                    final transitionProvider = Provider.of<TransitionProvider>(
                      context,
                      listen: false,
                    );

                    await transitionProvider.update(
                      Transition(
                        id: value!.id,
                        style: value.style,
                        isActive: Transition.VALUE_YES,
                      ),
                    );
                    setState(() {
                      selectedTransition = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 10),

              // Section 5 : Background Color
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField<BackgroundColor>(
                  decoration: InputDecoration(
                    labelText: 'Background Color',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedBackGroundColor,
                  items:
                      backgroundColorList.map((backGroundcolor) {
                        return DropdownMenuItem<BackgroundColor>(
                          value: backGroundcolor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                backGroundcolor.key,
                                style: TextStyle(fontSize: 16),
                              ),
                              if (backGroundcolor == selectedBackGroundColor)
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 26,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (BackgroundColor? value) async {
                    final backgroundcolorprovider =
                        Provider.of<Backgroundcolorprovider>(
                          context,
                          listen: false,
                        );

                    await backgroundcolorprovider.update(
                      BackgroundColor(
                        id: value!.id,
                        key: value.key,
                        colorsList: value.colorsList,
                        isActive: BackgroundColor.VALUE_YES,
                      ),
                    );
                    setState(() {
                      selectedBackGroundColor = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
