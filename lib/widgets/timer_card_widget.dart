// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerCardWidget extends StatefulWidget {
  final String bedNo;
  final String customerName;
  final DateTime startTime;
  final DateTime endTime;
  final VoidCallback onEnd;
  final VoidCallback onExtend;

  const TimerCardWidget({
    Key? key,
    required this.bedNo,
    required this.customerName,
    required this.startTime,
    required this.endTime,
    required this.onEnd,
    required this.onExtend,
  }) : super(key: key);

  @override
  _TimerCardWidgetState createState() => _TimerCardWidgetState();
}

class _TimerCardWidgetState extends State<TimerCardWidget> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();

    // Only start the timer if usage is ongoing
    if (DateTime.now().isBefore(widget.endTime)) {
      _startTimer();
    }
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    if (now.isBefore(widget.endTime)) {
      _timeLeft = widget.endTime.difference(now);

      final totalDuration =
          widget.endTime.difference(widget.startTime).inSeconds;
      final elapsed = now.difference(widget.startTime).inSeconds;
      _progress = elapsed / totalDuration;
    } else {
      _timeLeft = Duration.zero;
      _progress = 1.0;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _updateTimeLeft();

        // Check if time is up and perform the action
        if (_timeLeft <= Duration.zero) {
          _timer.cancel(); // Stop the timer
          widget.onEnd(); // Trigger the end callback
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Top Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bed No & Customer Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoTile(
                        'Bed ID',
                        ': ${widget.bedNo}',
                        Icons.bed,
                        Colors.brown,
                      ),
                      const Divider(),
                      _infoTile(
                        'Cust Name',
                        ': ${widget.customerName}',
                        Icons.person,
                        Colors.blue,
                      ),
                      const Divider(),
                      _infoTile(
                        'Start Time',
                        ': ${_formatTime(widget.startTime)}',
                        Icons.access_time,
                        Colors.orange,
                      ),
                      const Divider(),
                      _infoTile(
                        'End Time',
                        ': ${_formatTime(widget.endTime)}',
                        Icons.timelapse,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ),

                // Circular Timer
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 8.0,
                  percent: _progress.clamp(0.0, 1.0),
                  center: Text(
                    _timeLeft == Duration.zero
                        ? "Done"
                        : _formatDuration(_timeLeft),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  progressColor:
                      _timeLeft == Duration.zero ? Colors.green : Colors.blue,
                  backgroundColor: Colors.grey[300]!,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),

            //const SizedBox(height: 10),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: widget.onEnd,
                  icon: Icon(Icons.back_hand_rounded, color: Colors.red),
                  label: Text("End", style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: widget.onExtend,
                  icon: Icon(Icons.more_time, color: Colors.green),
                  label: Text("Extend", style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy : hh:mm a');
    return formatter.format(time);
  }

  Widget _infoTile(String label, String value, IconData iconData, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 20.0, color: color),
          SizedBox(width: 5.0),
          SizedBox(
            width: 80, // Fixed width for label column
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
