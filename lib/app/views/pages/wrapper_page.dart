import 'package:flutter/material.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nex'),
      ),
      body: Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}