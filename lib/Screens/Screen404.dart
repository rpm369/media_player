import 'package:flutter/material.dart';

class Screen404 extends StatelessWidget {
  const Screen404({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("404", style: TextStyle(color: Colors.white, fontSize: 50)),
      ),
    );
  }
}
