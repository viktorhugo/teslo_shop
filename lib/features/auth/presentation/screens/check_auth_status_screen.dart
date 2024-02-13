import 'package:flutter/material.dart';


class CheckAutStatusScreen extends StatelessWidget {
  const CheckAutStatusScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}