// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:urban_rest/pages/home_page.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              // Show Circle Option -1
              child: Image.asset(
                'assets/icon/icon.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 50),
            //Text("Notes"),
          ],
        ),
      ),
    );
  }
}
