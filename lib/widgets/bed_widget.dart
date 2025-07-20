import 'package:flutter/material.dart';

class BedWidget extends StatelessWidget {
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onTap;
  final int bedNumber;

  const BedWidget({
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
    required this.bedNumber,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (!isAvailable) {
      bgColor = Colors.grey[400]!;
    } else if (isSelected) {
      bgColor = Colors.green;
    } else {
      bgColor = Colors.white;
    }

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            if (isAvailable)
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bed,
                size: 28,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              SizedBox(height: 4),
              Text(
                'Bed $bedNumber',
                style: TextStyle(
                  color:
                      isSelected || !isAvailable ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
