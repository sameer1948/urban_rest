// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Urban Rest')),
//       body: Center(
//         child: Text(
//           'Welcome to the Home Page!',
//           style: TextStyle(fontSize: 22),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:urban_rest/widget/bed_widget.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _BedSelectionPageState createState() => _BedSelectionPageState();
// }

// class _BedSelectionPageState extends State<HomePage> {
//   List<bool> selectedBeds = List.generate(12, (index) => false);
//   List<bool> availableBeds = List.generate(12, (index) => true);

//   void toggleBed(int index) {
//     if (!availableBeds[index]) return;

//     setState(() {
//       selectedBeds[index] = !selectedBeds[index];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select Your Bed')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.builder(
//           itemCount: selectedBeds.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1,
//           ),
//           itemBuilder: (context, index) {
//             return BedWidget(
//               isSelected: selectedBeds[index],
//               isAvailable: availableBeds[index],
//               bedNumber: index + 1,
//               onTap: () => toggleBed(index),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
